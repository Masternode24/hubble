require 'features_helper'

describe 'avalanche account details' do
  let(:chain) { create(:avalanche_chain) }
  let(:address) { 'P-avax194jv0pfujykh5st2pn5hwmgl034728uexuth0t' }

  it 'visiting account details', :vcr do
    visit "/avalanche/chains/#{chain.slug}/accounts/#{address}"
    expect(page).to have_content('ACCOUNT INFORMATION')
    expect(page).to have_content('Balance')
    expect(page).to have_content('Locked Stakeable')
    expect(page).to have_content('Locked Not Stakeable')
    expect(page).to have_content('BDC')
  end
end
