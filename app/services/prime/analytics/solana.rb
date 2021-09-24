class Prime::Analytics::Solana
  BLOCKS_PER_EPOCH = 432000
  SECONDS_PER_DAY = 86400

  def initialize(network)
    Prime::Analytics::DataPoint.find_or_create_by(network: network, date: Date.current) do |data_point|
      data_point.network = network
      data_point.total_delegated_tokens = total_delegated_tokens(network)
      data_point.total_supply = total_supply(network)
      data_point.figment_delegated_tokens = figment_delegated_tokens(network)
      data_point.token_price = token_price(network)
      data_point.figment_daily_commission = figment_daily_commission(network)
      data_point.figment_effective_rate = figment_effective_rate(network)
      data_point.figment_commission_rate = figment_commission_rate(network)
      data_point.investor_rewards_net_apr = investor_rewards_net_apr(network)
    end
  end

  def total_delegated_tokens(network)
    @total_delegated_tokens ||= network.primary_chain.client.total_delegated_tokens
  end

  def total_supply(network)
    @total_supply ||= network.primary_chain.client.total_supply
  end

  def token_price(network)
    network.token_metrics!.price_usd
  end

  def figment_daily_commission(network)
    @figment_daily_commission ||= begin
      total_rewards = network.primary_chain.client.rewards(network.primary_chain.figment_validator_addresses, recent_completed_epoch(network)).sum { |reward| reward['amount'] }
      total_rewards.to_f / recent_epoch_duration(network)
    end
  end

  def figment_delegated_tokens(network)
    @figment_delegated_tokens ||= begin
      delegated = 0
      network.primary_chain.figment_validator_addresses.each do |address|
        delegated += network.primary_chain.client.validator_delegated_tokens(address)
      end
      delegated
    end
  end

  def investor_rewards_net_apr(network)
    calculated_reward_rate(network) * (1 - figment_commission_rate(network))
  end

  def figment_effective_rate(network)
    figment_daily_commission(network) * 365.25 / figment_delegated_tokens(network)
  end

  def figment_commission_rate(network)
    @figment_commission_rate ||= network.primary_chain.client.commission_rate(network.primary_chain.figment_validator_addresses.first, recent_completed_epoch(network))
  end

  def calculated_reward_rate(network)
    figment_daily_commission(network) * 365.25 / (figment_commission_rate(network) * figment_delegated_tokens(network))
  end

  def recent_completed_epoch(network)
    @recent_completed_epoch ||= network.primary_chain.client.current_epoch - 1
  end

  def recent_epoch_duration(network)
    start_block = (recent_completed_epoch(network) - 1) * BLOCKS_PER_EPOCH
    end_block = recent_completed_epoch(network) * BLOCKS_PER_EPOCH
    (network.primary_chain.client.block_time(end_block) - network.primary_chain.client.block_time(start_block)) / SECONDS_PER_DAY
  end
end
