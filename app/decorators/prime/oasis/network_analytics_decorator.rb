# TODO: Remove these decorator classes as we build out service objects to
# fetch analytics data and populate Prime::Analytics::DataPoint table

class Prime::Oasis::NetworkAnalyticsDecorator < Prime::NetworkAnalyticsDecorator
  def total_delegated
    @total_delegated ||= (primary_chain.client.validators.sum(&:recent_active_escrow_balance) / (10 ** primary_chain.reward_token_factor)) # .to_f / total_supply
  end

  def total_figment_delegation
    @figment_delegation_total ||= begin
      delegated_total = 0
      primary_chain.figment_validator_addresses.each do |validator|
        val = primary_chain.client.validator(validator, retrieve_delegations: false)
        delegated_total += val.recent_active_escrow_balance
      end
      delegated_total / (10 ** primary_chain.reward_token_factor)
    end
  end

  def figment_30_day_commission
    figment_1_day_commission * 30
  end

  def figment_effective_rate
    figment_1_day_commission * 365 / total_figment_delegation * 100
  end

  private

  def figment_1_day_commission
    @figment_1_day_commission ||= begin
      start = Time.now.utc - 1.day
      total_commission = 0
      primary_chain.figment_validator_addresses.each do |validator|
        total_commission += primary_chain.client.validator_commission(validator, self, { start: start.strftime('%Y-%m-%d') }).first.total_commission
      end
      total_commission.to_f / (10 ** primary_chain.reward_token_factor)
    end
  end
end
