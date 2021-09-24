class Prime::Admin::Analytics::NetworksController < Admin::BaseController
  def index
    @data_points = Prime::Analytics::DataPoint.latest.includes(:network)
    @team = params.has_key?(:team) ? params['team'] : 'accounting'
  end

  def show
    @network = Prime::Network.find_by!(name: params[:id])
  end
end
