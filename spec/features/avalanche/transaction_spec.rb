require 'features_helper'

describe 'avalanche transaction details' do
  let(:chain) { create(:avalanche_chain) }
  let(:tx) { '2AnoweWDb8dXWCCXxUH98fhGjYCwXnYFhUgPCDi9a5cKZcWRRp' }

  it 'visiting transaction details', :vcr do
    visit "/avalanche/chains/#{chain.slug}/transactions/#{tx}"
    expect(page).to have_text '2AnoweWDb8dXWCCXxUH98fhGjYCwXnYFhUgPCDi9a5cKZcWRRp'
    expect(page).to have_text 'Export'
    expect(page).to have_text 'Input Totals'
    expect(page).to have_text 'Destination Chain'
    expect(page).to have_text '671.511'
  end
end
