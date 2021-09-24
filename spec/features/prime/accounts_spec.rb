require 'features_helper'

describe 'Prime My Addressess' do
  include_context 'Prime Polkadot network chain account'
  include_context 'Prime Oasis network chain account'
  include_context 'Prime Near network chain account'

  context 'signed in prime user' do
    it 'displays Prime My Addresses', :vcr do
      travel_to Time.gm(2021, 0o7, 20, 14, 46, 17) do
        log_in(prime_user)
        VCR.use_cassette('Prime_My_Addressess/signed_in_prime_user/displays_Prime_My_Addresses', record: :new_episodes) do
          visit('/prime/accounts')
          expect(page).to have_content('Figment Prime')
          expect(page).to have_content('Polkadot')
          expect(page).to have_content('138QdRbUTB9eNY94Q4Mj5r39Fkg...')
          expect(page).to have_content('101.83 DOT')
          expect(page).to have_content('Oasis')
          expect(page).to have_content('oasis1qzkdwhw4hnu2pl49c6kpm...')
          expect(page).to have_content('27,862.66 ROSE')
          expect(page).to have_content('Near')
          expect(page).to have_content('figment.near')
          expect(page).to have_content('251,609.33 NEAR')
          expect(page).to have_content('582d15d089225c0595b14ac4359...')

          click_button('edit-oasis1qzkdwhw4hnu2pl49c6kpm8znh83uagvh9q7l8m2w-button')
          fill_in('Nickname', with: 'Oasis Account 1')
          click_button('Update Account Name')
          expect(page).to have_content('Account name has been updated!')
          expect(page).to have_content('Oasis Account 1')
        end
      end
    end
  end
end
