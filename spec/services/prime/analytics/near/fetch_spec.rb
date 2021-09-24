require 'rails_helper'

describe Prime::Analytics::Near do
  before do
    allow(network).to receive(:primary_chain).and_return(prime_chain)
    allow(chain).to receive(:token_factor).and_return(6)
    Prime::Analytics::Near.new(network)
  end

  let!(:network) { create(:prime_network, name: 'near') }
  let!(:prime_chain) do
    create(
      :prime_chain,
      network: network,
      type: 'Prime::Chains::Near',
      slug: 'near-1',
      reward_token_remote: 'near-protocol',
      reward_token_display: 'NEAR',
      reward_token_factor: 24,
      figment_validator_addresses: ['figment.poolv1.near']
    )
  end
  let!(:chain) do
    create(
      :near_chain,
      api_url: 'http://localhost:1111',
      primary: true
    )
  end
  let!(:factor) { 10 ** prime_chain.reward_token_factor }

  let!(:data_point) { Prime::Analytics::DataPoint.first }

  describe '#total_delegated_tokens', :vcr do
    let(:result) { data_point.total_delegated_tokens }

    it 'calculates the correct total number of delegated tokens' do
      expect((result / factor).round(0)).to eq(455138183)
    end
  end

  describe '#figment_delegated_tokens', :vcr do
    let(:result) { data_point.figment_delegated_tokens }

    it 'calculates the correct number of tokens delegated to Figment' do
      expect((result / factor).round(0)).to eq(5956691)
    end
  end

  describe '#figment_effective_rate', :vcr do
    let(:result) { data_point.figment_effective_rate }

    it 'calculates to correct effective commission rate' do
      expect(result.round(4)).to eq 0.0103
    end
  end

  describe 'figment_commission_rate', :vcr do
    let(:result) { data_point.figment_commission_rate }

    it 'calculates the correct commission rate' do
      expect(result).to eq 0.10
    end
  end

  describe '#investor_rewards_apr', :vcr do
    let(:result) { data_point.investor_rewards_net_apr }

    it 'calculates the correct APR' do
      expect(result.round(4)).to eq 0.0928
    end
  end
end
