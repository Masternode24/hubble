require 'features_helper'

describe 'cosmos validators' do
  let!(:chain) { create(:cosmos_chain) }
  let!(:validator) { create(:cosmos_validator_synced, chain: chain) }
  let!(:event) { create(:cosmos_event, chainlike: chain, validatorlike: validator) }
  let!(:block) { create(:cosmos_block, chain: chain) }

  it 'visiting Cosmos Events View as not signed in user' do
    visit "/cosmos/chains/#{chain.slug}/events"

    expect(page).to have_content(chain.name)
    expect(page).to have_content('1-1 of 1 total event')
    expect(page).to have_content("Added to active set #{event.height}")
  end
end
