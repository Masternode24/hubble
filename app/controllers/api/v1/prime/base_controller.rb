class Api::V1::Prime::BaseController < Api::V1::BaseController
  before_action :require_staking_access

  rescue_from Common::Client::NotFoundError, with: :resource_not_found

  protected

  def internal_customer_id
    @_customer_id ||= current_user.prime_eth_staking_customer_id
  end

  def anjin_client
    Prime::Anjin::Client.current
  end

  def require_staking_access
    unless current_user.prime_eth_staking_enabled && internal_customer_id.present?
      json_error(403, 'Staking management API is not available on your account')
    end
  end
end
