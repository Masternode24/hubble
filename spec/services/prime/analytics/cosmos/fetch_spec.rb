require 'rails_helper'

describe Prime::Analytics::Cosmos do
  before do
    allow(network).to receive(:primary_chain).and_return(prime_chain)
    allow(network).to receive(:figment_validators!).and_return([validator_1])
    allow(prime_chain).to receive(:figment_validator_addresses).and_return([validator_1.address])
    allow(validator_1).to receive(:current_commission).and_return(0.05)
    allow(validator_2).to receive(:current_commission).and_return(0.05)
    allow(chain).to receive(:token_factor).and_return(6)
    Prime::Analytics::Cosmos.new(network)
  end

  let!(:network) { create(:prime_network, name: 'cosmos') }
  let!(:prime_chain) do
    create(
      :prime_chain,
      network: network,
      type: 'Prime::Chains::Cosmos',
      slug: 'cosmos-1',
      reward_token_remote: 'cosmos',
      reward_token_display: 'ATOM',
      reward_token_factor: 6
    )
  end
  let!(:chain) do
    create(
      :cosmos_chain,
      network: network,
      rpc_host: 'localhost:1738',
      lcd_host: 'localhost:1738',
      rpc_path: '',
      lcd_path: ''
    )
  end
  let!(:validator_1) { create(:cosmos_validator, chain: chain, current_voting_power: 0.5e5) }
  let!(:validator_2) { create(:cosmos_validator, chain: chain, current_voting_power: 0.5e6) }
  let!(:data_point) { Prime::Analytics::DataPoint.first }

  describe '#total_delegated_tokens', :vcr do
    let(:result) { data_point.total_delegated_tokens }

    it 'calculates the correct total number of delegated tokens' do
      expect(result).to eq 550000000000.0
    end
  end

  describe '#figment_delegated_tokens', :vcr do
    let(:result) { data_point.figment_delegated_tokens }

    it 'calculates the correct number of tokens delegated to Figment' do
      expect(result).to eq 50000000000.0
    end
  end

  describe '#figment_effective_rate', :vcr do
    let(:result) { data_point.figment_effective_rate }

    it 'calculates the correct effective commission rate' do
      expect(result.round(2)).to eq 1.74
    end
  end

  describe 'figment_commission_rate', :vcr do
    let(:result) { data_point.figment_commission_rate }

    it 'calculates the correct commission rate' do
      expect(result.round(2)).to eq 0.05
    end
  end

  describe '#investor_rewards_apr', :vcr do
    let(:result) { data_point.investor_rewards_net_apr }

    it 'calculates the correct APR' do
      expect(result.round(2)).to eq 32.94
    end
  end
end
