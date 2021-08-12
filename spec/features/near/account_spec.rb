require 'features_helper'

describe 'near account page' do
  let(:chain) { create(:near_chain) }
  let(:account) { 'imperfect_triangle.near' }

  it 'visiting account details', :vcr do
    visit "/near/chains/#{chain.slug}/accounts/#{account}"
    expect(page).to have_content('ACCOUNT INFORMATION')
    expect(page).to have_content('Wallet Balance')
    expect(page).to have_content('Transactions')
    expect(page).to have_content('MORE INFORMATION')
  end
end
