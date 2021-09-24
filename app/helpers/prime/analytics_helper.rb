module Prime::AnalyticsHelper
  def analytics_active_tab(team)
    @team == team ? 'active' : ''
  end

  def factor_analytics_value(data_point, value)
    value / network_token_factor(data_point)
  end

  def sum_analytics_value(data_points, value)
    data_points.sum do |data_point|
      if data_point.has_attribute?(value)
        data_point[value] / network_token_factor(data_point)
      else
        data_point.send(value) / network_token_factor(data_point)
      end
    end
  end

  private

  def network_token_factor(data_point)
    10 ** data_point.network.primary_chain.reward_token_factor
  end
end
