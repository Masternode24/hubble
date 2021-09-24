class Prime::ProxyController < Prime::ApplicationController
  include ReverseProxy::Controller

  skip_before_action :verify_authenticity_token

  before_action :require_network
  before_action :require_chain

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def index
    reverse_proxy(
      @chain.rpc_uri.to_s,
      path: params[:path].presence || '/',
      headers: {
        'Authorization' => @chain.rpc_api_key,
        'Host' => @chain.rpc_host,
        'Connection' => 'Close'
      },
      http: {
        read_timeout: @chain.class::RPC_PROXY_READ_TIMEOUT,
        open_timeout: @chain.class::RPC_PROXY_OPEN_TIMEOUT
      }
    )
  end

  private

  def require_network
    @network ||= Prime::Network.find_by!(name: params[:network_id])
  end

  def require_chain
    @chain ||= require_network.chains.where.not(rpc_host: nil).find_by!(slug: params[:chain_id])
  end

  def render_not_found
    head :not_found
  end
end
