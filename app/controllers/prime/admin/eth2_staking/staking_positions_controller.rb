module Prime::Admin::Eth2Staking
  class StakingPositionsController < BaseController
    def index
      @positions = anjin_client.staking_positions
    end
  end
end
