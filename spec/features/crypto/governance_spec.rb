require 'features_helper'

describe 'crypto validators' do
  let!(:chain) { create(:crypto_chain) }
  let!(:proposal) { create(:crypto_governance_proposal, chain: chain, total_deposit: [{ 'denom': 'basecro', 'amount': '51200000' }]) }
  let!(:below_threshold_proposal) { create(:crypto_governance_proposal, ext_id: 28, title: 'Prop with < 10 percent deposits', chain: chain, total_deposit: [{ 'denom': 'basecro', 'amount': '51199999' }]) }

  it 'visiting Crypto Governance Index as not signed in user' do
    visit "/crypto/chains/#{chain.slug}/governance"

    expect(page).to have_content(chain.name)
    expect(page).to have_content(proposal.title)
    expect(page).not_to have_content(below_threshold_proposal.title)
  end

  it 'visiting Crypto Governance View as not signed in user' do
    visit "/crypto/chains/#{chain.slug}/governance/proposals/#{proposal.ext_id}"

    expect(page).to have_content(chain.name)
    expect(page).to have_content(proposal.title)
    expect(page).to have_content('33.4%')
  end
end
