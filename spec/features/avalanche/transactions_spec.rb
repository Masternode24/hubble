require 'features_helper'

describe 'avalanche transactions', :vcr do
  let(:chain) { create(:avalanche_chain) }

  before do
    visit avalanche_chain_transactions_path(chain)
  end

  it 'displays transaction search' do
    visit "/avalanche/chains/#{chain.slug}/transactions"
    expect(page).to have_text 'Search'
    expect(page).to have_text 'Filter Transactions'
    expect(page).to have_text 'Search Results'
    expect(page).to have_link 'Validators', href: avalanche_chain_path(chain)

    within '.transactions-search-form' do
      expect(page).to have_text 'Account'
      expect(page).to have_text 'Start Date'
      expect(page).to have_text 'Tx Memo'
    end

    within '.transactions-search-results' do
      expect(page.all('tbody > tr').size).to eq 25
    end
  end

  context 'search' do
    before do
      fill_in 'Account (Sender/Receiver)', with: 'avax1slt2dhfu6a6qezcn5sgtagumq8ag8we75f84sw'
      click_on 'Search'
    end

    it 'displays search results' do
      within '.transactions-search-results' do
        expect(page).to have_text 'TYPE'
        expect(page).to have_text 'Transfer'
        expect(page).to have_text 'FEE'
      end
    end

    it 'allows to reset the filter' do
      expect { click_on 'Reset Filters' }.
        to change { page.find('#search_account').value }.
        from('avax1slt2dhfu6a6qezcn5sgtagumq8ag8we75f84sw').to('')
    end

    it 'redirects to the transaction page' do
      within '.transactions-search-results' do
        within page.find('tbody > tr:first-child') do
          click_on 'details'
          expect(page).to have_current_path "/avalanche/chains/#{chain.slug}/transactions/2Gv5ZFB5LA1H1196Lz8PMmRF5jUaoepqsmKQzE3dYQdEcCW5qL"
        end
      end
    end
  end

  context 'empty search' do
    before do
      fill_in 'Account (Sender/Receiver)', with: 'something that does not exist'
      click_on 'Search'
    end

    it 'displays empty search results' do
      within '.transactions-search-results' do
        expect(page).to have_text 'No transactions found'
      end
    end
  end
end
