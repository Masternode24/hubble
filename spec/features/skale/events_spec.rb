require 'features_helper'

describe 'skale events page' do
  let(:chain) { create(:skale_chain) }

  it 'visiting skale events page', :vcr do
    visit "/skale/chains/#{chain.slug}/events"
    expect(page).to have_content('Events')
    expect(page).to have_content('BLOCK')
    expect(page).to have_content('Page 1')
  end

  it 'visiting skale validator specific events and pagination', :vcr do
    visit "/skale/chains/#{chain.slug}/events?id=19&page=2"

    expect(page).to have_content('Events')
    expect(page).to have_content('BLOCK')
    expect(page).to have_content('ChorusOne')
    expect(page).to have_content('12733741')
    expect(page).to have_content('Page 2')
  end
end
