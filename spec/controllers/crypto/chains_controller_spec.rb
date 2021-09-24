require 'rails_helper'

RSpec.describe Crypto::ChainsController do
  let(:chain) { create(:crypto_chain) }
  let(:id) { chain.slug }

  describe 'GET #show' do
    subject { get :show, params: { network: chain.network_name.downcase, id: id } }

    context 'when chain is present' do
      it 'does not return 404' do
        subject
        expect(response).not_to have_http_status(:not_found)
      end
    end

    context 'when chain is not present' do
      let(:id) { 'absent-id' }

      it 'returns 404 status' do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'get #search' do
    subject { get :search, params: { network: chain.network_name.downcase, id: id } }

    context 'when search is not present' do
      it 'does not return 500' do
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when search query is blank' do
      let(:query) { '' }

      it 'does not return 500' do
        subject
        expect(response).not_to have_http_status(:internal_server_error)
      end
    end
  end

  describe 'get #halted' do
    subject { get :halted, params: { network: chain.network_name.downcase, id: id } }

    context 'when validator_states raises an error' do
      it 'does not return 500' do
        chain.update(halted_at: 2.hours.ago)
        allow_any_instance_of(chain.namespace::HaltedChainService).to receive(:validator_states).and_raise(Cosmoslike::SyncBase::CriticalError)
        subject
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
