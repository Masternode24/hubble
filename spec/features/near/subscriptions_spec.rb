require 'features_helper'

describe 'near subscriptions' do
  let!(:chain) { create(:near_chain) }
  let!(:alertable) { create(:alertable_address, chain: chain, address: 'bisontrails.poolv1.near') }
  let!(:user) { create(:user) }
  let!(:alert_subscription) do
    create(:alert_subscription,
           user: user,
           alertable: alertable)
  end

  context 'logged out' do
    it 'visiting Near Validators Subscriptions View as not signed in user', :vcr do
      visit "/near/chains/#{chain.slug}/validators/#{alertable.address}/subscriptions"
      expect(page).to have_content('Login')
    end
  end

  context 'logged in' do
    it 'visiting Near Validators Subscriptions View as signed in user', :vcr do
      log_in(user)

      visit "/near/chains/#{chain.slug}/validators/#{alertable.address}/subscriptions"

      expect(page).to have_content('Kicked')
      expect(page).to have_content('Joined/Left the Active Set')
      expect(page).to have_content('Receive Daily Digest?')
    end
  end
end
