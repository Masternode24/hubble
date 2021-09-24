module Prime::Admin::Eth2Staking
  class ValidatorsController < BaseController
    def index
      @validators = anjin_client.validators
    end

    def show
      @validator = anjin_client.validator(params[:id])
    end
  end
end
