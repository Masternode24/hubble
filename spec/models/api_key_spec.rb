require 'rails_helper'

describe ApiKey do
  let(:user) { create :user }
  let(:key) { create :api_key, user: user }

  it 'requires user' do
    key = described_class.new
    expect(key).not_to be_valid
    expect(key.errors[:user]).to include 'must exist'

    key.user = user
    expect(key).to be_valid
  end

  it 'generates key' do
    key = create(:api_key, user: user)
    expect(key.key).not_to be_blank
  end

  describe '#active?' do
    it 'returns true if active' do
      expect(key.active?).to eq true

      key.update(deactivated_at: Time.current)
      expect(key.active?).to eq false
    end
  end

  describe '#deactivate' do
    it 'deactivates the key' do
      expect { key.deactivate }.
        to change(key, :deactivated_at).from(nil).to(Time).
        and change(key, :deactivated?).from(false).to(true).
        and change(key, :status).from('active').to('deactivated')
    end
  end
end
