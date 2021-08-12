require 'features_helper'
require 'download_helper'

describe 'Prime Rewards' do
  let(:prime_user) { create(:user, prime: true) }
  let!(:polkadot) { create(:prime_network, name: 'Polkadot') }
  let!(:near) { create(:prime_network, name: 'Near') }

  let!(:polkadot_chain) do
    create(:prime_chain,
           network: polkadot,
           name: 'Polkadot',
           slug: 'polkadot',
           api_url: 'http://localhost:2222')
  end

  let!(:near_chain) do
    create(:prime_chain,
           network: near,
           name: 'Mainnet',
           slug: 'mainnet',
           type: 'Prime::Chains::Near',
           api_url: 'https://localhost:3333',
           reward_token_factor: 24,
           reward_token_remote: 'near',
           reward_token_display: 'NEAR')
  end

  let!(:polkadot_account) do
    create(:prime_account,
           user: prime_user,
           network: polkadot)
  end

  let!(:near_account) do
    create(:prime_account,
           user: prime_user,
           network: near,
           type: 'Prime::Accounts::Near',
           address: 'figment.near')
  end

  context 'signed in prime user' do
    before do
      travel_to Time.gm(2021, 0o7, 20, 14, 46, 17) do
        log_in(prime_user)
        visit('/prime/rewards')
      end
    end

    it 'displays Prime Rewards Page', :vcr do
      expect(page).to have_content('Figment Prime')
      expect(page).to have_content('My Rewards')
      expect(page).to have_content('CSV FILES')
      expect(page).to have_content('97.16 DOT')
      expect(page).to have_content('($1,050.21)')
      expect(page).to have_content('4,049 NEAR')
      expect(page).to have_content('($6,645.08)')

      expect(page).to have_content('REWARDS OVERVIEW')

      expect(page).to have_content('14ShUZUYUR35RBZW6...')
      expect(page).to have_content('0.44 DOT')
      expect(page).to have_content('$5.25')
      expect(page).to have_content('figment.poolv1.near')
      expect(page).to have_content('204.93 NEAR')
      expect(page).to have_content('$378.01')
    end

    it 'displays Rewards Page with name', :vcr do
      travel_to Time.gm(2021, 0o7, 20, 14, 46, 17) do
        polkadot_account.name = 'hello'
        polkadot_account.save
        polkadot_account.reload
        near_account.name = 'hi there'
        near_account.save
        near_account.reload
        visit current_path

        expect(page).to have_content('Name (Address)')
        expect(page).to have_content('hello')
        expect(page).to have_content('hi there')
      end
    end

    it 'checks downloaded CSV', :vcr do
      filename = 'daily-rewards-report.csv'
      click_button('CSV', match: :first)

      expect(DownloadHelpers.download_content(filename)).to include 'USD Equiv'

      DownloadHelpers.clear_downloads(filename)
    end
  end
end
