FactoryBot.define do
  factory :prime_analytics_data_point, class: 'Prime::Analytics::DataPoint' do
    date { Date.current }
    total_supply { 1_000_000 }
    total_delegated_tokens { 900_000 }
    figment_delegated_tokens { 100_000 }
    token_price { 20.00 }
    figment_daily_commission { 100 }
    figment_commission_rate { 0.1 }
    figment_effective_rate { 0.9 }
    investor_rewards_net_apr { 0.1 }
    network factory: :prime_network
  end
end
