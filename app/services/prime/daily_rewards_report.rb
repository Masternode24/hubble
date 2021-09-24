class Prime::DailyRewardsReport
  FIELDS = %i[
    date
    name
    address
    reward
    commission
    currency
    token_price
    reward_usd_equiv
    commission_usd_equiv
    validator
  ].freeze

  def initialize(user, network)
    @user = user
    @network = network
  end

  def to_csv(start_time: nil, end_time: nil)
    data = rewards_to_rows(user_network_accounts, start_time, end_time)
    fields = Common::CsvExporter.filter_unused_fields(FIELDS, data)
    Common::CsvExporter.new(data, fields).call
  end

  private

  def user_network_accounts
    Prime::Account.for_user(@user.id).for_network(@network.id)
  end

  def rewards_to_rows(accounts, start_time, end_time)
    rows = []
    total_commission = accounts.map { |account| account.rewards(start_time, end_time).sum(&:commission) }.sum
    accounts.each do |account|
      token_hash = account.network.daily_price_series_hash
      factor = account.network.primary_chain.reward_token_factor
      account.rewards(start_time, end_time).each do |reward|
        factored_reward = reward.amount.to_f / (10 ** factor)
        factored_commission = reward.commission.to_f / (10 ** factor) if reward.commission != 0
        reward_usd_equivalent, commission_usd_equivalent = usd_equivalent(account.network.primary_chain, reward, token_hash)
        commission_usd_equivalent = nil if commission_usd_equivalent == 0
        rows << {
          date: reward.time,
          name: account.name,
          address: account.address,
          reward: factored_reward,
          commission: factored_commission,
          currency: reward.token_display,
          token_price: token_price(reward.time, token_hash),
          reward_usd_equiv: reward_usd_equivalent,
          commission_usd_equiv: commission_usd_equivalent,
          validator: reward.validator_address
        }
      end
    end
    rows.sort! { |a, b| b[:date] <=> a[:date] }
  end

  def format_timestamp(stamp)
    Time.strptime(stamp.to_s, '%s').to_s.split(' ').first
  end

  def token_price(stamp, token_hash)
    token_hash[format_timestamp(stamp.to_i)] || 0
  end

  def usd_equivalent(primary, reward, token_hash)
    if reward.token_display == primary.reward_token_display
      factor = token_price(reward.time, token_hash) / (10 ** primary.reward_token_factor)
    elsif reward.token_display == 'USD'
      factor = 1.0 / (10 ** primary.reward_token_factor)
    end
    factor.present? ? [reward.amount.to_f * factor, reward.commission.to_f * factor] : [nil, nil]
  end
end
