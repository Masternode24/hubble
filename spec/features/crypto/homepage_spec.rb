require 'features_helper'

describe 'crypto home' do
  let!(:chain) { create(:crypto_chain) }

  it 'visiting halted Crypto Home View as not signed in user', :vcr do
    visit "crypto/chains/#{chain.slug}"

    expect(page).to have_content(chain.name)
    expect(page).to have_content('Validators in Last Round')
    expect(page).to have_content('ROUND INFO')
  end
end
