require 'features_helper'

describe 'Celo governance' do
  let!(:chain) { create(:celo_chain) }

  it 'shows a list of proposals', :vcr do
    visit "/celo/chains/#{chain.slug}/governance"

    expect(page).to have_content('Governance Proposals')
    expect(page).to have_content('91471')
    expect(page).to have_content('EXECUTED')
  end
end
