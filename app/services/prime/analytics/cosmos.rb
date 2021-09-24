class Prime::Analytics::Cosmos < Prime::Analytics::Base
  delegate :reported_inflation, to: :lcd_client
  delegate :community_tax, to: :lcd_client

  def total_delegated_tokens
    chain.validators.sum(&:current_voting_power) * token_factor_multiplier
  end

  def total_supply
    lcd_client.total_supply(chain.primary_token)
  end

  def token_price
    network.token_metrics!.price_usd
  end

  def figment_daily_commission
    figment_delegated_tokens.to_f * calculated_reward_rate * figment_commission_rate / 365.25
  end

  def figment_delegated_tokens
    chain.validators.where(address: network.primary_chain.figment_validator_addresses).sum(&:current_voting_power) * token_factor_multiplier
  end

  def investor_rewards_net_apr
    (1 - figment_commission_rate) * calculated_reward_rate
  end

  def figment_effective_rate
    calculated_reward_rate * figment_commission_rate
  end

  def figment_commission_rate
    network.figment_validators!.first.current_commission
  end

  def calculated_reward_rate
    supply = total_supply
    (reported_inflation * (1 - community_tax)) / (total_delegated_tokens / supply)
  end

  def token_factor_multiplier
    10 ** chain.token_factor
  end

  def chain
    ::Cosmos::Chain.primary
  end

  def lcd_client
    ::Cosmos::LcdClient.new(chain.lcd_url)
  end
end
