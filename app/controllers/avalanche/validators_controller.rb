class Avalanche::ValidatorsController < Avalanche::BaseController
  def show
    @current_page = params[:page].present? ? params[:page].to_i : 1

    raise ActiveRecord::RecordNotFound if @current_page < 1

    @validator = client.validator(params[:id])
    raise ActiveRecord::RecordNotFound unless @validator

    opts = { item_id: params[:id].gsub('NodeID-', ''), item_type: 'validator' }

    @events = client.events(@current_page, opts)

    @validator_hourly_uptime_avg = client.validator(@validator.validator.node_id).stats_24h.map do |validator_stats_summary|
      Avalanche::UptimeChartDecorator.new(validator_stats_summary).point
    end

    @alertable_address = AlertableAddress.find_by(chain: @chain, address: @validator.validator.node_id)

    page_title 'Validator Details'
    meta_description 'Avalanche Validator Details'
  end
end
