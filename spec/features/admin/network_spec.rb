require 'features_helper'

# in the future these should be done as controller tests

describe 'Admin page' do
  let!(:admin) { create(:admin) }

  let!(:oasis) { create(:prime_network, name: 'Oasis') }
  let!(:polkadot) { create(:prime_network, name: 'Polkadot') }

  before do
    visit '/prime/admin'

    fill_in 'email', with: admin.email
    fill_in 'password', with: admin.password

    click_button 'login'
  end

  it 'adds a new network' do
    find("a[href='/prime/admin/networks/new'").click

    expect(page).to have_content('New Network')
    fill_in 'prime_network_name', with: 'Prime Network'
    click_button 'Create Network'

    expect(page).to have_content('Network created successfully.')
    expect(page).to have_content('New Network')
  end

  it 'edits the name of an existing network' do
    find("a[href='/prime/admin/networks/polkadot/edit']").click

    fill_in 'prime_network_name', with: 'updated network'
    click_button 'Update Network'

    expect(page).not_to have_content('Polkadot')
    expect(page).to have_content('Updated network')
  end

  it 'deletes an existing network' do
    click_button('delete', match: :first)
    click_button 'confirm?'

    expect(page).to have_content('Network has been deleted!')
    expect(page).not_to have_content('Oasis')
  end
end
