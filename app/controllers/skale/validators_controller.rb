class Skale::ValidatorsController < Skale::BaseController
  def show
    staked_from = 6.months

    # Events table pagination
    @current_page = params[:page].present? ? params[:page].to_i : 1
    raise ActiveRecord::RecordNotFound if @current_page < 1

    @validator = client.validator(params[:id])
    raise ActiveRecord::RecordNotFound unless @validator

    @nodes = client.nodes(validator_id: @validator.id)
    @staked_stats = total_staked(staked_from)
    @delegation_summary = client.delegation_summary(validator_id: @validator.id, time_at: Time.now.iso8601)
    @delegations = client.delegations(validator_id: @validator.id, timeline: 'false').sort_by(&:state)
    @events = client.events(@current_page, { validator_id: params[:id] }, page_limit: 10)

    @alertable_address = AlertableAddress.find_by(chain: @chain, address: @validator.id)

    page_title 'Validator'
    meta_description "Validator #{@validator.name}"
  end

  private

  def total_staked(staked_from)
    client.staked_over_time(id: @validator.id, from: staked_from.ago.iso8601, to: Time.now.iso8601, timeline: 'true', type: 'TOTAL_STAKE').reverse.map do |validator_summary|
      Skale::StakedChartDecorator.new(validator_summary).point(@chain)
    end
  end
end
