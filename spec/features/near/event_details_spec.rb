require 'features_helper'

describe 'near event details page' do
  let(:chain) { create(:near_chain) }
  let(:event_id) { '735' }

  it 'visiting event details page', :vcr do
    visit "/near/chains/#{chain.slug}/events/#{event_id}"
    expect(page).to have_content('Validator Event for sweden.poolv1.near')
    expect(page).to have_content('left the active set of validators 38505055')
    expect(page).to have_content('May 28, 2021 at 08:33')
  end
end
