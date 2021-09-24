class Prime::Analytics::Near < Prime::Analytics::Base
  def total_delegated_tokens
    @total_delegated_tokens ||= client.validators.sum(&:stake)
  end

  def total_supply
    @total_supply ||= client.current_block.total_supply.to_f
  end

  def token_price
    network.token_metrics!.price_usd
  end

  def figment_daily_commission
    @figment_daily_commission ||= figment_delegated_tokens * calculated_reward_rate * figment_commission_rate / 365.25
  end

  def figment_delegated_tokens
    @figment_delegated_tokens ||= client.validators.select do |validator|
      network.primary_chain.figment_validator_addresses.include? validator.account_id
    end.sum(&:stake)
  end

  def investor_rewards_net_apr
    calculated_reward_rate * (1 - figment_commission_rate)
  end

  def figment_effective_rate
    figment_daily_commission * 365.25 / figment_delegated_tokens
  end

  def figment_commission_rate
    @figment_commission_rate ||= client.validator(network.primary_chain.figment_validator_addresses.first).reward_fee.to_f / 100
  end

  def calculated_reward_rate
    Prime::Chains::Near::FIXED_INFLATION_RATE / (total_delegated_tokens / total_supply)
  end

  def client
    ::Near::Chain.primary.client
  end
end
