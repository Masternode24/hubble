require 'features_helper'

describe 'celo events overview' do
  let(:chain) { create(:celo_chain) }

  it 'visiting events overview', :vcr do
    visit "/celo/chains/#{chain.slug}/events?page=2"
    expect(page).to have_content('VALIDATOR')
    expect(page).to have_content('BLOCK')
    expect(page).to have_content('DATE')
    expect(page).to have_content('syncnode')
  end
end
