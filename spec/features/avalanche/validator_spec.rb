require 'features_helper'

describe 'avalanche validator details' do
  let(:chain) { create(:avalanche_chain) }
  let(:address) { 'NodeID-EiLtFTxRYttP5EcHc9Ap6SBQvaXkbUKxT' }

  it 'visiting validator details', :vcr do
    visit "/avalanche/chains/#{chain.slug}/validators/#{address}"
    expect(page).to have_content('Staking Balance')
    expect(page).to have_content('Beneficiary')
    expect(page).to have_content('Delegation Fee')
    expect(page).to have_content('P-avax13wxm09a4ctjhl7xxh4p3jay29x3fqlfmsrs30q')
    expect(page).to have_content('5,344.636 AVAX')
  end
end
