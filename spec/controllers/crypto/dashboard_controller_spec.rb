require 'rails_helper'

RSpec.describe Crypto::DashboardController do
  let(:chain) { create(:crypto_chain) }
  let(:user) { build(:user) }

  before { allow(controller).to receive(:current_user).and_return(user) }

  describe 'GET #index' do
    subject { get :index, params: { chain_id: chain.slug, network: 'crypto' } }

    it { is_expected.to have_http_status(:ok) }
  end
end
