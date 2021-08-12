class Avalanche::AccountsController < Avalanche::BaseController
  include Pagy::Backend

  def show
    @stripped_account_address = strip_chain_prefix(params[:id])
    @account = client.account(@stripped_account_address)
    raise ActiveRecord::RecordNotFound unless @account

    @assets = client.assets.index_by(&:id)
    validators = client.validators(reward_address: prefixed_address(@stripped_account_address))
    delegations = client.delegations(reward_address: prefixed_address(@stripped_account_address))
    @pagination_validators, @validators = pagy_array(validators, page_param: :validator_page)
    @pagination_delegations, @delegations = pagy_array(delegations, page_param: :delegator_page)
  end

  private

  def strip_chain_prefix(account)
    account.split('-').last
  end

  def prefixed_address(address, prefix = 'P-')
    "#{prefix}#{address}"
  end
end
