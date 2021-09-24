require 'rails_helper'

describe User do
  describe '#mfa_required?' do
    let(:user) { User.new }

    context 'regular user' do
      it 'is optional' do
        expect(user.mfa_required?).to eq false
      end
    end

    context 'with staking enabled' do
      before do
        user.prime = true
        user.prime_eth_staking_enabled = true
      end

      it 'is required' do
        expect(user.mfa_required?).to eq true
      end
    end
  end

  describe '#enable_mfa' do
    let(:user) { create :user }

    before do
      allow(user).to receive(:authenticate_otp).with('GOOD').and_return(true)
      allow(user).to receive(:authenticate_otp).with('BAD').and_return(false)
    end

    it 'requires otp code' do
      expect(user.enable_mfa(nil)).to eq false
      expect(user.errors[:base]).to include 'OTP code is required'
    end

    it 'skips when already enabled' do
      user.update(otp_secret_key: 'foo', otp_enabled: true)

      expect(user.enable_mfa('12345')).to eq false
      expect(user.errors[:base]).to include 'MFA is already enabled'
    end

    it 'requires otp secret key' do
      user.otp_secret_key = nil

      expect(user.enable_mfa('12345')).to eq false
      expect(user.errors[:base]).to include 'MFA configuration is not complete'
    end

    it 'checks the code' do
      expect(user.enable_mfa('BAD')).to eq false
      expect(user.errors[:base]).to include 'OTP code is not valid'

      expect(user.enable_mfa('GOOD')).to eq true
      expect(user.otp_enabled).to eq true
      expect(user.otp_enabled_at).to be_a Time
    end
  end

  describe '#disable_mfa' do
    let(:user) { create :user, otp_enabled: true, otp_enabled_at: Time.current }

    it 'reset otp flag' do
      expect { user.disable_mfa }.
        to change(user, :otp_enabled).from(true).to(false).
        and change(user, :otp_enabled_at).to(nil)
    end
  end

  describe '#mfa_enabled?' do
    it 'returns true when complete' do
      user = User.new
      expect(user.mfa_enabled?).to eq false

      user.otp_secret_key = 'foo'
      user.otp_enabled = true
      expect(user.mfa_enabled?).to eq true
    end
  end

  context 'eth staking customer validation' do
    let(:api) { double(Prime::Anjin::Client) }

    before do
      allow(Prime::Anjin::Client).to receive(:current) { api }
    end

    context 'prime is not enabled' do
      let(:user) { create :user, prime: false }

      it 'does not check customer id' do
        expect(api).not_to receive(:customer)
        expect(user.update(prime_eth_staking_customer_id: 'ID')).to eq true
        expect(user.reload.prime_eth_staking_customer_id).to eq 'ID'
      end
    end

    context 'prime is enabled' do
      let(:user) { create :user, prime: true }

      it 'skips validation when customer ID is not provided' do
        expect(api).not_to receive(:customer)
        expect(user.update(prime_eth_staking_customer_id: '')).to eq true
      end

      it 'skips validation on unrelated changes' do
        expect(api).not_to receive(:customer)
        expect(user.update(email: 'foo@bar.com')).to eq true
      end

      it 'validates customer ID' do
        expect(api).to receive(:customer).with('ID')
        expect(user.update(prime_eth_staking_customer_id: 'ID')).to eq true
        expect(user.reload.prime_eth_staking_customer_id).to eq 'ID'
      end

      it 'validates invalid customer ID' do
        expect(api).to receive(:customer).with('ID') { raise Common::Client::NotFoundError, 'Invalid customer' }
        expect(user.update(prime_eth_staking_customer_id: 'ID')).to eq false
        expect(user.errors[:prime_eth_staking_customer_id]).to include 'is not a valid customer ID'
      end
    end
  end
end
