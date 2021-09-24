require 'features_helper'

describe 'crypto account' do
  let!(:chain) { create(:crypto_chain) }
  let!(:account) { create(:crypto_account, chain: chain, address: 'tcro14fzksz5h72et4ssjtqpwsmhz6ysk6r4ngtg6zj') }

  it 'visiting Crypto Account View as not signed in user', :vcr do
    visit "/crypto/chains/#{chain.slug}/accounts/#{account.address}"

    expect(page).to have_content(chain.name)
    expect(page).to have_content(account.address)
    expect(page).to have_content('BALANCE')
    expect(page).to have_content('DELEGATION')
    expect(page).to have_content('PENDING REWARDS')
    expect(page).to have_content('Delegations')
    expect(page).to have_content('Recent Delegation Transactions')
  end
end
