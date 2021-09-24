require 'features_helper'

describe 'crypto validators' do
  let!(:chain) { create(:crypto_chain) }
  let!(:validator) { create(:crypto_validator_synced, chain: chain) }
  let!(:event) { create(:crypto_event, chainlike: chain, validatorlike: validator) }

  it 'visiting Crypto Single Event View as not signed in user' do
    visit "/crypto/chains/#{chain.slug}/events/#{event.id}"

    expect(page).to have_content(chain.name)
    expect(page).to have_content("Validator Event for #{validator.moniker}")
    expect(page).to have_content('This is the most recent event for this validator')
  end
end
