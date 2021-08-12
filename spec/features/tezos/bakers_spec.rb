require 'features_helper'

def visit_baker_page(id)
  visit "/tezos/bakers/#{id}"
end

describe 'baker details' do
  let!(:chain) { create(:tezos_chain) }
  let(:baker_id) { 'tz2Q7Km98GPzV1JLNpkrQrSo5YUhPfDp6LmA' }
  let(:user) { create(:user) }

  it 'visit as not signed in user and try to subscribe', :vcr do
    visit_baker_page(baker_id)
    expect(page).to have_content(baker_id)

    click_link('Subscribe')
    expect(page).to have_current_path('/users/new')
  end
end
