class Api::V1::Prime::Eth2Staking::HomeController < Api::V1::Prime::BaseController
  def show
    render json: {
      staked_amount: staking_positions.sum(&:staked_eth_amount),
      positions: staking_positions.size,
      validators: staking_positions.sum { |pos| pos.validators.size }
    }
  end

  private

  def staking_positions
    @positions ||= anjin_client.staking_positions(customer_id: internal_customer_id)
  end
end
