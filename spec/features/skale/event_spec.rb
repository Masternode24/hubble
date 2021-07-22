require 'features_helper'

describe 'skale event page' do
  let(:chain) { create(:skale_chain) }
  let(:event_id) { 'b0d5fb1d-a064-4093-9d36-2720a38207fd' }

  it 'visiting skale event details page', :vcr do
    visit "/skale/chains/#{chain.slug}/events/#{event_id}"
    expect(page).to have_content('Validator Event for')
    expect(page).to have_content('BACK')
    expect(page).to have_content('show all')
  end
end
