class Celo::ValidatorsController < Celo::BaseController
  include Pagy::Backend

  SEQUENCES_LIMIT = 50

  def show
    @validator = client.validator(params[:id], sequences_limit: SEQUENCES_LIMIT)
    raise ActiveRecord::RecordNotFound unless @validator

    @validator_scores = client.validator_daily_score(@validator.address).map do |validator_summary|
      Celo::ScoresChartDecorator.new(validator_summary).point
    end
    @validator_hourly_uptime = client.validator_hourly_uptime(@validator.address).map do |validator_summary|
      Common::UptimeChartDecorator.new(validator_summary).point
    end
    @alertable = AlertableAddress.find_or_initialize_by(chain: @chain, address: @validator.address)

    events = client.validator_events(chain: @chain, address: @validator.address)
    @pagination, @events = pagy_array(events)

    page_title @chain.network_name, @chain.name, @validator.display_name, 'Scores, Uptime and Event History'
    meta_description 'Scores History, Uptime History, Commission, Activity and Event History'
  end
end
