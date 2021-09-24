require 'features_helper'
require 'download_helper'

describe 'Prime Rewards' do
  context 'signed in prime user' do
    include_context 'Prime Polkadot network chain account'
    include_context 'Prime Oasis network chain account'
    include_context 'Prime Near network chain account'
    include_context 'Prime Cosmos network chain account'
    include_context 'Prime Terra network chain account'

    before do
      travel_to Time.gm(2021, 8, 11, 20, 28, 26) do
        log_in(prime_user)
        visit('/prime/rewards')
      end
    end

    it 'displays Prime Rewards Page', :vcr do
      expect(page).to have_content('Figment Prime')
      expect(page).to have_content('My Rewards')
      expect(page).to have_content('CSV FILES')
      expect(page).to have_content('5,882.12 DOT')
      expect(page).to have_content('($145,411.87)')
      expect(page).to have_content('7,777.81 NEAR')
      expect(page).to have_content('($40,079.87)')

      expect(page).to have_content('REWARDS OVERVIEW')
      expect(page).to have_content('Name (Address)')
      expect(page).to have_content('account 0')
      expect(page).to have_content('Cosmos')
      expect(page).to have_content('Polkadot')
      expect(page).to have_content('Terra')

      expect(page).to have_content('terravaloper1krj7...')
      expect(page).to have_content('0.00')
    end

    it 'checks downloaded CSV', :vcr do
      filename = 'prime-polkadot-daily-rewards-report.csv'

      click_link(href: '/prime/rewards.csv?network=polkadot')

      expect(DownloadHelpers.download_content(filename)).to include 'Name'
      expect(DownloadHelpers.download_content(filename)).to include 'USD Equiv'

      DownloadHelpers.clear_downloads(filename)
    end
  end
end
