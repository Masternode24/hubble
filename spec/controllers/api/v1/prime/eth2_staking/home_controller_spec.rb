require 'rails_helper'

describe Api::V1::Prime::Eth2Staking::HomeController do
  let(:user) do
    create :user,
           prime: true,
           prime_eth_staking_enabled: true,
           prime_eth_staking_customer_id: 'CUSTOMER'
  end

  let(:api_key) { create :api_key, user: user }
  let(:client) { double(Prime::Anjin::Client) }
  let(:json) { JSON.parse(response.body) }

  before do
    allow(Prime::Anjin::Client).to receive(:current) { client }
    allow(client).to receive(:customer).with('CUSTOMER').and_return({})
    allow(client).to receive(:staking_positions).and_return([])

    request.headers['Authorization'] = api_key.key
  end

  context 'auth' do
    let(:user) { create :user }

    before do
      request.headers['Authorization'] = nil
    end

    it 'returns error when key is missing' do
      get :show

      expect(response.status).to eq 401
      expect(json['error']).to eq 'Invalid API key'
    end

    it 'returns errors with invalid key' do
      get :show, params: { api_key: 'foobar' }

      expect(response.status).to eq 401
      expect(json['error']).to eq 'Invalid API key'
    end

    it 'requires staking management feature' do
      get :show, params: { api_key: api_key.key }

      expect(response.status).to eq 403
      expect(json['error']).to eq 'Staking management API is not available on your account'
    end

    it 'validated key passed in the header' do
      request.headers['Authorization'] = "Bearer #{api_key.key}"
      get :show

      expect(response.status).to eq 403
      expect(json['error']).to eq 'Staking management API is not available on your account'
    end
  end

  describe '#show' do
    before do
      get :show
    end

    it 'returns summary' do
      expect(response.status).to eq 200
    end
  end
end
