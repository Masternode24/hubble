class Api::V1::Prime::Eth2Staking::ValidatorsController < Api::V1::Prime::BaseController
  def index
    json_response(staking_positions.flat_map { |pos| pos.validators })
  end

  def show
    json_response(anjin_client.validator(params[:id]))
  end

  private

  def staking_positions
    @positions ||= anjin_client.staking_positions(customer_id: internal_customer_id)
  end
end
