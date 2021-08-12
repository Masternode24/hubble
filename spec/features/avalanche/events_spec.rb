require 'features_helper'

describe 'avalanche events overview' do
  let(:chain) { create(:avalanche_chain) }

  it 'visiting events overview', :vcr do
    visit "/avalanche/chains/#{chain.slug}/events"
    expect(page).to have_content('Events')
    expect(page).to have_content('EVENT')
    expect(page).to have_content('BLOCK')
    expect(page).to have_content('DATE')
  end
end
