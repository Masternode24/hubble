require 'features_helper'

describe 'crypto validators' do
  let!(:chain) { create(:crypto_chain) }
  let!(:validator) { create(:crypto_validator_synced, chain: chain) }
  let!(:event) { create(:crypto_event, chainlike: chain, validatorlike: validator) }
  let!(:block) { create(:crypto_block, chain: chain) }

  it 'visiting Crypto Events View as not signed in user' do
    visit "/crypto/chains/#{chain.slug}/events"

    expect(page).to have_content(chain.name)
    expect(page).to have_content('1-1 of 1 total event')
    expect(page).to have_content("Added to active set #{event.height}")
  end
end
