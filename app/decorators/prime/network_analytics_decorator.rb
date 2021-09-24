# TODO: Remove these decorator classes as we build out service objects to
# fetch analytics data and populate Prime::Analytics::DataPoint table

class Prime::NetworkAnalyticsDecorator < SimpleDelegator
  def network_share
    100 * total_figment_delegation.to_f / total_delegated
  end

  def figment_annualized_commission
    figment_30_day_commission * 365 / 30
  end

  def figment_30_day_commission
    0
  end

  def figment_effective_rate
    0
  end
end
