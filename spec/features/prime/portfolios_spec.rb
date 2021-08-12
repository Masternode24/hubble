require 'features_helper'

describe 'Prime Portfolio' do
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
    it 'displays Prime Portfolio', :vcr do
      travel_to Time.gm(2021, 0o7, 20, 14, 46, 17) do
        log_in(prime_user)
        visit('/prime/portfolio')

        expect(page).to have_content('Portfolio')
        expect(page).to have_content('NETWORKS OVERVIEW')
        expect(page).to have_content('PORTFOLIO OVERVIEW')
        expect(page).to have_content('Portfolio Distribution')
        expect(page).to have_content('Portfolio Performance')
        expect(page).to have_content('4,049 NEAR')
        expect(page).to have_content('861 ROSE')
        expect(page).to have_content('5,882.12 DOT')
        expect(page).to have_content('CURRENT TOTAL: $3,287.18')
      end
    end
  end
end
