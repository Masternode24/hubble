require 'features_helper'

describe 'cosmos transactions' do
  let!(:chain) { create(:cosmos_chain, name: 'Cosmoshub 4', slug: 'cosmoshub-4', tx_search_url: 'https://localhost:1111/transactions_search', tx_search_enabled: true) }
  let!(:chain_without_search) { create(:cosmos_chain) }

  it 'visiting Cosmos Transaction Search View as not signed in user', :vcr do
    visit "/cosmos/chains/#{chain.slug}/transactions"

    expect(page).to have_content(chain.name)
    expect(page).not_to have_content(chain_without_search.name)
    expect(page).to have_content('Cosmoshub-4')
    expect(page).to have_content('Page 1')
    expect(page).to have_content('7087638')
    expect(page).to have_content('Send')

    find('#next-page', match: :first).click
    expect(page).to have_content('Page 2')
    expect(page).to have_content('7087612')

    fill_in 'search_accounts_array', with: 'cosmos1hjct6q7npsspsg3dgvzk3sdf89spmlpfg8wwf7'
    click_button 'Search'

    expect(page).to have_content(chain.name)
    expect(page).to have_content('Cosmoshub-4')
    expect(page).to have_content('Send')
    expect(page).to have_content('6953880')

    fill_in 'Start Height:', with: '12345'
    fill_in 'End Height:', with: '1234'
    click_button 'Search'

    expect(page).to have_content('Start Height must be less than or equal to End Height')

    fill_in 'Start Date:', with: '2020-11-10'
    fill_in 'End Date:', with: '2020-11-01'
    click_button 'Search'

    expect(page).to have_content('Start Date must be less than or equal to End Date')
  end
end
