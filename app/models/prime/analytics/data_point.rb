class Prime::Analytics::DataPoint < ApplicationRecord
  belongs_to :network, class_name: 'Prime::Network'

  validates :total_delegated_tokens, :total_supply, :figment_delegated_tokens, :token_price,
            :figment_commission_rate, :figment_effective_rate, :investor_rewards_net_apr, :figment_daily_commission,
            presence: true, numericality: { greater_than: 0 }

  scope :latest, -> { select('DISTINCT ON ("network_id") *').order(:network_id, date: :desc) }
  scope :for_network, ->(network) { where(network: network) }

  def staking_participation
    total_delegated_tokens / total_supply
  end

  def figment_staking_share
    figment_delegated_tokens / total_delegated_tokens
  end

  def figment_delegated_usd
    figment_delegated_tokens * token_price
  end

  def figment_monthly_commission
    figment_daily_commission * 30
  end

  def figment_monthly_commission_usd
    figment_monthly_commission * token_price
  end

  def figment_annualized_commission
    figment_daily_commission * 365.25
  end

  def figment_annualized_commission_usd
    figment_annualized_commission * token_price
  end

  def network_market_cap
    total_supply * token_price
  end

  def investor_rewards_gross_apr
    investor_rewards_net_apr / (1 - figment_commission_rate)
  end

  def investor_monthly_compounded_apy
    ((1 + (investor_rewards_net_apr / 12)) ** 12) - 1
  end

  # Figment annual USD revenue per $1mm in delegated tokens
  def network_profitability
    1_000_000 * figment_annualized_commission_usd / (figment_delegated_tokens * token_price)
  end
end
