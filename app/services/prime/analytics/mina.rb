class Prime::Analytics::Mina
  delegate :client, to: :chain

  def initialize(network)
    Prime::Analytics::DataPoint.find_or_create_by(network: network, date: Date.current) do |data_point|
      data_point.total_delegated_tokens = total_delegated_tokens
      data_point.total_supply = total_supply
      data_point.figment_delegated_tokens = figment_delegated_tokens(network)
      data_point.token_price = token_price(network)
      data_point.figment_daily_commission = figment_daily_commission(network)
      data_point.figment_effective_rate = figment_effective_rate(network)
      data_point.figment_commission_rate = figment_commission_rate(network)
      data_point.investor_rewards_net_apr = investor_rewards_net_apr(network)
    end
  end

  def total_delegated_tokens
    client.validators.sum(&:stake)
  end

  def total_supply
    client.current_block.total_currency
  end

  def token_price(network)
    network.token_metrics!.price_usd
  end

  def figment_daily_commission(network)
    network.primary_chain.figment_validators.sum { |validator| client.validator_daily_rewards(validator.public_key, 1.day.ago) }
  end

  def figment_delegated_tokens(network)
    network.primary_chain.figment_validators.sum(&:stake)
  end

  def investor_rewards_net_apr(network)
    (1 - figment_commission_rate(network)) * calculated_reward_rate(network)
  end

  def figment_effective_rate(network)
    calculated_reward_rate(network) * figment_commission_rate(network)
  end

  def figment_commission_rate(network)
    network.primary_chain.class.name.constantize::FIXED_FIGMENT_COMMISSION_RATE
  end

  def calculated_reward_rate(network)
    daily_rewards = figment_daily_commission(network) / figment_commission_rate(network)
    daily_rewards * 365.25 / figment_delegated_tokens(network)
  end

  def token_factor_multiplier
    10 ** chain.token_factor
  end

  def chain
    ::Mina::Chain.primary
  end
end
