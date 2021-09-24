require 'features_helper'

describe 'Prime Homepage', :vcr do
  let(:prime_user) { create(:user, prime: true) }
  let!(:polkadot) { create(:prime_network, name: 'Polkadot') }
  let!(:oasis) { create(:prime_network, name: 'Oasis') }

  let!(:polkadot_chain) do
    create(:prime_chain,
           network: polkadot,
           api_url: 'http://localhost:2222')
  end

  let!(:oasis_chain) do
    create(:prime_chain,
           network: oasis,
           api_url: 'https://localhost:1111',
           name: 'Mainnet',
           slug: 'mainnet',
           type: 'Prime::Chains::Oasis',
           reward_token_remote: 'oasis-labs',
           active: false)
  end

  before do
    log_in(prime_user)
    visit('/prime')
  end

  context 'signed in without prime access' do
    let(:prime_user) { create :user, prime: false }

    it 'displays signup page' do
      expect(page).to have_content 'Become a Prime Member'
    end
  end

  context 'signed in prime user' do
    it 'displays Prime homepage' do
      expect(page).to have_content('Figment Prime')
      expect(page).to have_content('Polkadot')
      expect(page).not_to have_content('Oasis')
      expect(page).not_to have_content('Coming to Prime Soon!')
      expect(page).to have_content('1-Day Performance:')
      expect(page).to have_content('NETWORK UPDATES')
      expect(page).to have_content('Multi-Blockchain Support')
      expect(page).to have_content('NETWORK CALENDAR')
      expect(page).to have_content('FIGMENT VALIDATORS PERFORMANCE')
      expect(page).to have_content('Polkadot (138QdRbUTB9eNY9...)')
      expect(page).to have_content('98.09%')

      within '.sidebar > nav' do
        expect(page).to have_link 'Home', href: prime_root_path
        expect(page).to have_link 'Portfolio', href: prime_portfolio_path
        expect(page).to have_link 'Rewards', href: prime_rewards_path
        expect(page).to have_link 'Validator Performance', href: prime_validators_path
        expect(page).to have_link 'Network News & Events', href: prime_events_path
        expect(page).to have_link 'My Addresses', href: prime_accounts_path
        expect(page).to have_link 'My Profile', href: prime_profile_path
        expect(page).not_to have_link 'ETH Staking', href: prime_eth2_staking_path
      end
    end

    context 'user has eth staking turned on' do
      let(:prime_user) do
        create :user,
               prime: true,
               prime_eth_staking_enabled: true,
               prime_eth_staking_customer_id: '958dbd70-eef7-4563-9cd5-0f8a765772ad'
      end

      it 'displays navigation item' do
        within '.sidebar > nav' do
          expect(page).to have_link 'ETH Staking', href: prime_eth2_staking_path
        end
      end
    end
  end
end
