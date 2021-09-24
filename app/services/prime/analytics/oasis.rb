class Prime::Analytics::Oasis < Prime::Analytics::Base
  OASIS_COMMISSION_FACTOR = 100000

  delegate :client, to: :chain

  def total_delegated_tokens
    network.primary_chain.client.validators.sum(&:recent_active_escrow_balance)
  end

  def total_supply
    client.staking.total_supply.to_f - client.staking.common_pool.to_f
  end

  def token_price
    network.token_metrics!.price_usd
  end

  def figment_daily_commission
    @figment_daily_commission ||= begin
      start = Time.now.utc - 1.day
      total_commission = 0
      network.primary_chain.figment_validator_addresses.each do |validator|
        total_commission += client.validator_commission(validator, network, { start: start.strftime('%Y-%m-%d') }).first.total_commission
      end
      total_commission.to_f
    end
  end

  def figment_delegated_tokens
    @figment_delegated_tokens ||= begin
      delegated_total = 0
      network.primary_chain.figment_validator_addresses.each do |validator|
        val = client.validator(validator, retrieve_delegations: false)
        delegated_total += val.recent_active_escrow_balance
      end
      delegated_total.to_f
    end
  end

  def investor_rewards_net_apr
    (1 - figment_commission_rate) * calculated_reward_rate
  end

  def figment_effective_rate
    figment_daily_commission * 365.25 / figment_delegated_tokens
  end

  def figment_commission_rate
    validator_address = network.figment_validators!.first.address
    client.validator(validator_address).recent_commission.to_f / OASIS_COMMISSION_FACTOR
  end

  def calculated_reward_rate
    address = network.primary_chain.figment_validator_addresses.first
    start_time = 1.day.ago.strftime('%Y-%m-%d')
    end_time = 1.day.ago.strftime('%Y-%m-%d')
    client.validator_rewards(address, start_time, end_time).first['apr'].to_f
  end

  def token_factor_multiplier
    10 ** chain.token_factor
  end

  def chain
    ::Oasis::Chain.primary
  end
end
