require 'features_helper'

describe 'avalanche event details' do
  let(:chain) { create(:avalanche_chain) }
  let(:address) { 'F6vYX6vQNBxUMXV6y4gk2dGz5LvhHcigrjeYPKweCfVKuzQ3f' }

  it 'visiting event details', :vcr do
    visit "/avalanche/chains/#{chain.slug}/events/#{address}"
    expect(page).to have_content('Validator Event for')
    expect(page).to have_content('Delegation Finished')
    expect(page).to have_content('Transaction details')
    expect(page).to have_content('Show all Validator Events')
  end
end
