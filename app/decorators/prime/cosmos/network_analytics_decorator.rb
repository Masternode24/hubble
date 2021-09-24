# TODO: Remove these decorator classes as we build out service objects to
# fetch analytics data and populate Prime::Analytics::DataPoint table

class Prime::Cosmos::NetworkAnalyticsDecorator < Prime::NetworkAnalyticsDecorator
  def total_delegated
    @total_delegated ||= begin
      chain.staked_amount / (10 ** chain.token_map[chain.primary_token]['factor'])
    end
  end

  def total_figment_delegation
    @figment_delegation_total ||= begin
      Cosmos::Chain.primary.validators.where(address: primary_chain.figment_validator_addresses).sum(:current_voting_power)
    end
  end

  def figment_30_day_commission
    @figment_30_day_commission ||= begin
      figment_annualized_commission * 30 / 365
    end
  end

  def figment_annualized_commission
    total_figment_delegation.to_f * calculated_reward_rate * figment_commission_rate
  end

  def figment_effective_rate
    calculated_reward_rate * figment_commission_rate * 100
  end

  private

  def calculated_reward_rate
    @calculated_inflation ||= begin
      supply = total_supply / (10 ** primary_chain.reward_token_factor)
      (reported_inflation * (1 - community_tax)) / (total_delegated / supply)
    end
  end

  def figment_commission_rate
    @figment_commission_rate ||= figment_validators!.first.current_commission
  end

  def chain
    Cosmos::Chain.primary
  end

  def syncer
    Cosmos::SyncBase.new(chain)
  end

  def reported_inflation
    syncer.get_reported_inflation
  end

  def total_supply
    syncer.get_total_supply
  end

  def community_tax
    syncer.get_community_tax
  end
end
