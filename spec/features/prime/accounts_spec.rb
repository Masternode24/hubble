require 'features_helper'

describe 'Prime My Addressess' do
  let!(:prime_user) { create(:user, prime: true) }
  let!(:polkadot) { create(:prime_network, name: 'Polkadot') }
  let!(:oasis) { create(:prime_network, name: 'Oasis') }
  let!(:near) { create(:prime_network, name: 'Near') }

  let!(:polkadot_chain) do
    create(:prime_chain,
           network: polkadot,
           name: 'Polkadot',
           slug: 'polkadot',
           api_url: 'http://localhost:2222')
  end

  let!(:oasis_chain) do
    create(:prime_chain,
           network: oasis,
           name: 'Mainnet',
           slug: 'mainnet',
           type: 'Prime::Chains::Oasis',
           api_url: 'https://localhost:1111',
           reward_token_factor: 9,
           reward_token_remote: 'rose',
           reward_token_display: 'ROSE')
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
           network: polkadot,
           address: '138QdRbUTB9eNY94Q4Mj5r39FkgMiyHCAy8UFMNA5gvtrfSB')
  end

  let!(:oasis_account) do
    create(:prime_account,
           user: prime_user,
           network: oasis,
           type: 'Prime::Accounts::Oasis',
           address: 'oasis1qzkdwhw4hnu2pl49c6kpm8znh83uagvh9q7l8m2w')
  end

  let!(:near_account) do
    create(:prime_account,
           user: prime_user,
           network: near,
           type: 'Prime::Accounts::Near',
           address: 'figment.near')
  end

  context 'signed in prime user' do
    it 'displays Prime My Addresses', :vcr do
      travel_to Time.gm(2021, 0o7, 20, 14, 46, 17) do
        log_in(prime_user)
        VCR.use_cassette('Prime_My_Addressess/signed_in_prime_user/displays_Prime_My_Addresses', record: :new_episodes) do
          visit('/prime/accounts')
          expect(page).to have_content('Figment Prime')
          expect(page).to have_content('Polkadot')
          expect(page).to have_content('138QdRbUTB9eNY94Q4Mj5r39Fkg...')
          expect(page).to have_content('101.85 DOT')
          expect(page).to have_content('Oasis')
          expect(page).to have_content('oasis1qzkdwhw4hnu2pl49c6kpm...')
          expect(page).to have_content('24,704.33 ROSE')
          expect(page).to have_content('Near')
          expect(page).to have_content('figment.near')
          expect(page).to have_content('531.94 NEAR')

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
