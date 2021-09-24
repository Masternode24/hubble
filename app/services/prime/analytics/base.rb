class Prime::Analytics::Base
  attr_accessor :network

  def initialize(network)
    self.network = network

    data_point = Prime::Analytics::DataPoint.find_or_create_by(network: network, date: Date.current) do |data_point|
      data_point.total_delegated_tokens = total_delegated_tokens
      data_point.total_supply = total_supply
      data_point.figment_delegated_tokens = figment_delegated_tokens
      data_point.token_price = token_price
      data_point.figment_daily_commission = figment_daily_commission
      data_point.figment_effective_rate = figment_effective_rate
      data_point.figment_commission_rate = figment_commission_rate
      data_point.investor_rewards_net_apr = investor_rewards_net_apr
    end

    if data_point.new_record? && data_point.errors.any?
      Rollbar.error("Error saving Prime Analytics Data Point. Errors: #{data_point.errors.full_messages.join(', ')}")
    end
  rescue StandardError => e
    Rollbar.error("Error fetching data for Prime Analytics Data Point: #{e}")
    raise e
  end
end
