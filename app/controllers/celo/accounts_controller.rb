class Celo::AccountsController < Celo::BaseController
  def show
    @account = Celo::AccountDecorator.new(client.account(params[:id]))
    @account_details = client.account_details(params[:id])

    page_title @chain.network_name, @chain.name, @account_details.display_name
    meta_description "Balance, Transfers and Transactions for #{@account_details.display_name}"
  rescue Common::IndexerClient::Error => e
    @account = Celo::Account.failed(params[:id])
    @account_details = Celo::AccountDetails.failed(params[:id])
    @error = e
  end
end
