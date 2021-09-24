require 'features_helper'

describe 'Prime ETH Staking', :vcr do
  let(:prime_user) do
    create :user,
           prime: true,
           prime_eth_staking_enabled: true,
           prime_eth_staking_customer_id: '958dbd70-eef7-4563-9cd5-0f8a765772ad'
  end

  let!(:polkadot) { create(:prime_network, name: 'Polkadot') }

  let!(:polkadot_chain) do
    create(:prime_chain,
           network: polkadot,
           api_url: 'http://localhost:2222')
  end

  before do
    allow_any_instance_of(User).to receive(:authenticate_otp).and_return(true)

    log_in(prime_user)
    confirm_otp(prime_user)
    visit(prime_eth2_staking_path)
  end

  context 'signed in without prime staking access' do
    let(:prime_user) { create :user, prime: true, prime_eth_staking_enabled: false }

    it 'redirects back to prime homepage' do
      expect(page).to have_current_path prime_root_path
      expect(page).to have_content 'Sorry, Ethereum staking management is not available on your account.'
    end
  end

  it 'displays current staking positions' do
    expect(page).to have_content 'MY STAKING POSITIONS'
    expect(page).to have_content 'Unnamed Position'
    expect(page).to have_content '96 ETH'
    expect(page).to have_content '0xDC25EF3F5B8A186998338A2ADA83795FBA2D695E'
  end

  describe 'api keys' do
    context 'without MFA' do
      it 'displays MFA call to action' do
        expect(page).to have_content 'Multi-Factor Authentication is Required!'
        expect(page).to have_content 'Before you can start using the Staking Management API, please enable MFA on your account.'

        click_on 'Setup MFA on Your Account'
        expect(page).to have_current_path prime_profile_path
      end
    end

    context 'with MFA' do
      let(:prime_user) do
        create :user,
               prime: true,
               prime_eth_staking_enabled: true,
               prime_eth_staking_customer_id: '958dbd70-eef7-4563-9cd5-0f8a765772ad',
               otp_enabled: true
      end

      it 'displays no keys' do
        expect(page).to have_content 'No API keys found'
        expect(page).to have_link 'Create a new API key', href: prime_api_keys_path
        expect(page).to have_link 'API documentation', href: prime_eth2_staking_docs_path
      end

      it 'manages api keys' do
        click_on 'Create a new API key'
        accept_confirm
        expect(page).to have_content 'New API key has been created'
        expect(page).to have_content prime_user.api_keys.first.key

        page.find('a.delete-btn').click
        accept_confirm
        expect(page).to have_content 'API key has been deactivated'
        expect(page).to have_content 'No API keys found'
      end
    end
  end
end
