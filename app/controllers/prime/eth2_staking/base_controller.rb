class Prime::Eth2Staking::BaseController < Prime::ApplicationController
  before_action :set_metadata
  before_action :require_eth_staking

  private

  def set_metadata
    @page_title = 'Ethereum Staking Management'
  end

  def anjin_client
    Prime::Anjin::Client.current
  end

  def require_eth_staking
    # Primary feature flag check on customer level
    unless current_user.prime_eth_staking_enabled
      flash[:error] = 'Sorry, Ethereum staking management is not available on your account.'
      return redirect_to prime_root_path
    end

    # In case if customer ID gets deleted
    if current_user.prime_eth_staking_customer_id.blank?
      flash[:error] = 'Sorry, Ethereum staking management is temporarily unavailable on your account.'
      redirect_to prime_root_path
    end
  end
end
