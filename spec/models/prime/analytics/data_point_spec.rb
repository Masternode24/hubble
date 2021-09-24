require 'rails_helper'

RSpec.describe Prime::Analytics::DataPoint, type: :model do
  describe '.latest' do
    it 'returns the most recent data point for each network' do
      cosmos = create(:prime_network, name: 'Cosmos')
      near = create(:prime_network, name: 'Near')

      (Date.yesterday..Date.current).each do |date|
        create(:prime_analytics_data_point, network: cosmos, date: date)
        create(:prime_analytics_data_point, network: near, date: date)
      end

      all_data_points = described_class.all
      latest_data_points = described_class.latest
      expect(all_data_points.count).to eq 4
      expect(latest_data_points.length).to eq 2
      expect(latest_data_points).to be_all { |data_point| data_point.date == Date.current }
    end

    it 'works when latest dates are not the same' do
      cosmos = create(:prime_network, name: 'Cosmos')
      near = create(:prime_network, name: 'Near')

      (Date.yesterday..Date.current).each do |date|
        create(:prime_analytics_data_point, network: cosmos, date: date)
        create(:prime_analytics_data_point, network: near, date: date)
      end
      create(:prime_analytics_data_point, network: near, date: Date.tomorrow)

      all_data_points = described_class.all
      latest_data_points = described_class.latest
      expect(all_data_points.count).to eq 5
      expect(latest_data_points.length).to eq 2
      latest_data_points.each do |data_point|
        if data_point.network == cosmos
          expect(data_point.date).to eq Date.current
        elsif data_point.network == near
          expect(data_point.date).to eq Date.tomorrow
        end
      end
    end
  end

  describe '#staking_participation' do
    it 'calculates the correct value' do
      data_point = build(
        :prime_analytics_data_point,
        total_delegated_tokens: 100,
        total_supply: 1000
      )
      expect(data_point.staking_participation).to eq 0.10
    end
  end

  describe '#figment_staking_share' do
    it 'calculates the correct value' do
      data_point = build(
        :prime_analytics_data_point,
        total_delegated_tokens: 100,
        figment_delegated_tokens: 99
      )
      expect(data_point.figment_staking_share).to eq 0.99
    end
  end

  describe '#figment_delegated_usd' do
    it 'calculates the correct value' do
      data_point = build(
        :prime_analytics_data_point,
        figment_delegated_tokens: 100,
        token_price: 20
      )
      expect(data_point.figment_delegated_usd).to eq 2000.0
    end
  end

  describe '#network_profitability' do
    it 'calculates the correct value' do
      data_point = build(
        :prime_analytics_data_point,
        figment_daily_commission: 100,
        token_price: 20,
        total_delegated_tokens: 800_000
      )
      expect(data_point.network_profitability).to eq 365250.0
    end
  end

  describe 'validations' do
    %i[total_delegated_tokens total_supply figment_delegated_tokens token_price figment_commission_rate figment_effective_rate investor_rewards_net_apr figment_daily_commission].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
      it { is_expected.to validate_numericality_of(attr).is_greater_than(0) }
    end
  end
end
