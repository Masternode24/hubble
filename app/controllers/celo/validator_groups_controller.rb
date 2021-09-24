class Celo::ValidatorGroupsController < Celo::BaseController
  def show
    @validator_group = client.validator_group(params[:id])
    @validators = client.validators(params[:id])
    raise ActiveRecord::RecordNotFound unless @validator_group

    page_title @chain.network_name, @chain.name, @validator_group.display_name, 'Votes and Validators'
    meta_description 'Votes, Average Uptime, Commission and Validators'
  end
end
