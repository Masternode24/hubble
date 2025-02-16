require 'features_helper'

describe 'Admin user page' do
  let!(:admin) { create(:admin) }
  let!(:oasis_account) do
    create(:prime_account,
           user: prime_user,
           network: oasis,
           type: 'Prime::Accounts::Oasis',
           address: 'oasis1qzkdwhw4hnu2pl49c6kpm8znh83uagvh9q7l8m2w')
  end
  let!(:polkadot_account) do
    create(:prime_account,
           user: prime_user,
           network: polkadot,
           address: '138QdRbUTB9eNY94Q4Mj5r39FkgMiyHCAy8UFMNA5gvtrfSB')
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
  let!(:polkadot_chain) do
    create(:prime_chain,
           network: polkadot,
           name: 'Polkadot',
           slug: 'polkadot',
           api_url: 'http://localhost:2222')
  end

  let!(:prime_user) { create(:user, prime: true) }
  let!(:polkadot) { create(:prime_network, name: 'Polkadot') }
  let!(:oasis) { create(:prime_network, name: 'Oasis') }

  before do
    visit '/admin'

    fill_in 'email', with: admin.email
    fill_in 'password', with: admin.password

    click_button 'login'
  end

  it 'displays Prime address for the user', :vcr do
    visit('/admin/users')
    expect(page).to have_content('Active with 2 addresses')

    click_link 'Details'
    expect(page).to have_content('Polkadot')
    expect(page).to have_content('138QdRbUTB9eNY94Q4Mj5r39Fkg')
    expect(page).to have_content('Oasis')
    expect(page).to have_content('oasis1qzkdwhw4hnu2pl49c6kpm')
  end
end
