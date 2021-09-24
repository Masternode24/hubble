class Prime::Eth2Staking::HomeController < Prime::Eth2Staking::BaseController
  def index
    @staking = Prime::StakingDecorator.new(positions: fetch_staking_positions)
    @api_keys = current_user.api_keys.order(created_at: :asc).select(&:active?)
  end

  def docs
    @api_key = current_user.api_keys.active.first&.key || 'YOUR_API_KEY'
  end

  private

  def fetch_staking_positions
    anjin_client.staking_positions(customer_id: current_user.prime_eth_staking_customer_id)
  rescue StandardError => err
    flash[:error] = "Sorry, we're not able to fetch staking positions at this time."
    Rollbar.error(err) if Rails.env.production?
    []
  end
end
