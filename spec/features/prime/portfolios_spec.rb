require 'features_helper'

describe 'Prime Portfolio' do
  include_context 'Prime Polkadot network chain account'
  include_context 'Prime Oasis network chain account'
  include_context 'Prime Near network chain account'

  context 'signed in prime user' do
    it 'displays Prime Portfolio', :vcr do
      travel_to Time.gm(2021, 8, 10, 14, 46, 17) do
        log_in(prime_user)
        visit('/prime/portfolio')

        expect(page).to have_content('Portfolio')
        expect(page).to have_content('NETWORKS OVERVIEW')
        expect(page).to have_content('PORTFOLIO OVERVIEW')
        expect(page).to have_content('Portfolio Distribution')
        expect(page).to have_content('Portfolio Performance')
        expect(page).to have_content('7,672.99 NEAR')
        expect(page).to have_content('1,013.42 ROSE')
        expect(page).to have_content('5,882.12 DOT')
        expect(page).to have_content('CURRENT TOTAL: $1,301,727.40')
      end
    end
  end
end
