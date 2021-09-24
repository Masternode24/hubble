module Prime::RewardsCalculationHelper
  def factored_amount(reward)
    reward.amount.to_f / (10 ** reward.token_factor)
  end

  def usd_equivalent(reward)
    if reward.token_display == reward.account.network.primary.reward_token_display
      return number_to_currency(reward_in_usd(reward.time, [reward], reward.account.network))
    elsif reward.token_display == 'USD'
      return number_to_currency(reward.amount.to_f / (10 ** reward.account.network.primary.reward_token_factor))
    else
      return nil
    end
  end

  def account_reward_total(network, rewards, factor, token)
    account_total = 0
    rewards.group_by(&:token_display).each do |token_display, rewards|
      if token_display == token
        account_total += rewards.sum(&:amount).to_f / (10 ** factor)
      elsif token_display == 'USD'
        account_total += rewards.sum(&:amount).to_f / (10 ** factor * network.price_usd)
      end
    end
    account_total
  end

  def reward_in_usd(time, reward_group, network)
    # TO DO - what to return if no pricing available??
    formatted_time = format_reward_timestamp(time)
    if network.daily_price_series_hash.has_key? formatted_time
      (network.daily_price_series_hash[formatted_time] || 0) * reward_group.sum(&:amount) / (10 ** network.primary.reward_token_factor)
    else
      0
    end
  end
end
