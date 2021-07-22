require 'features_helper'

describe 'Cosmos transaction details' do
  let(:chain) { create(:cosmos_chain) }
  let(:transaction_id) { '2C78D613E90560ACA814BB839154BE762FB5B8F2905BDA90C24A18F30411AF9C' }
  let(:block_id) { 6743338 }

  it 'visiting Transaction View as not signed in user', :vcr do
    visit "/cosmos/chains/#{chain.slug}/blocks/#{block_id}/transactions/#{transaction_id}"
    expect(page).to have_content(chain.name)
    expect(page).to have_content(block_id)
    expect(page).to have_content('cosmos1xgkz8r62kf3emvew5hnu3mcfa2tz95f0990g7d')
    expect(page).to have_content('200,000 GAS')
    expect(page).to have_content('151,480 GAS')
  end
end
