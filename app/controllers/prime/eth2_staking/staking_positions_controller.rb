class Prime::Eth2Staking::StakingPositionsController < Prime::Eth2Staking::BaseController
  def show
    @position = anjin_client.staking_position(params[:id])
  end

  def funding
    @position = anjin_client.staking_position(params[:id])
  end
end
