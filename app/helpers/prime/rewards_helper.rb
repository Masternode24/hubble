module Prime::RewardsHelper
  PAYOUT_DISPLAY_TIMEFRAME = 30.days.freeze

  def network_reward_total(network, start_time: nil, end_time: nil)
    total_rewards = 0
    factor = network.primary_chain.reward_token_factor
    token = network.primary_chain.reward_token_display
    current_user.prime_accounts.for_network(network.id).includes([:network]).each do |account|
      total_rewards += account_reward_total(network, account.rewards(start_time, end_time), factor, token)
    end
    total_rewards
  end

  def payout_display_time
    Time.now - PAYOUT_DISPLAY_TIMEFRAME
  end

  def build_reward_history_chart_data(start_time: nil, end_time: nil)
    series = []
    enabled_networks.each do |network|
      network_rewards = user_rewards(start_time: start_time, end_time: end_time).select { |reward| reward.account.network.id == network.id }
      filtered_network_rewards = network_rewards.select { |reward| allowed_tokens(network).include? reward.token_display }
      daily_rewards = filtered_network_rewards.group_by_day(&:time).map { |k, v| [k, reward_in_usd(k, v, network)] }
      monthly_rewards = daily_rewards.group_by_month { |day| day[0] }.map { |k, v| [k, v.sum { |r| r[1] }] }
      series << {
        name: network.name.capitalize,
        data: monthly_rewards
      }
    end
    series.select { |s| s[:data].present? }
  end

  def reward_history_chart_options
    {
      stacked: true,
      tooltip: tooltips_to_usd,
      yaxis: labels_to_usd,
      data_labels: false,
      stroke: { curve: 'smooth', width: 3 }
    }
  end

  private

  def format_reward_timestamp(time)
    time.to_s.split(' ').first
  end

  def allowed_tokens(network)
    [network.primary.reward_token_display, 'USD']
  end
end
