require 'features_helper'

describe 'skale events page' do
  let(:chain) { create(:skale_chain) }

  it 'visiting skale events page', :vcr do
    visit "/skale/chains/#{chain.slug}/events"
    expect(page).to have_content('Events')
    expect(page).to have_content('BLOCK')
    expect(page).to have_content('Page 1')
  end
end
