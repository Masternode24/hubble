class Celo::TransactionsController < Celo::BaseController
  def show
    @transaction = client.transaction(params[:block_id], params[:id])
    raise ActionController::NotFound unless @transaction

    page_title @chain.network_name, @chain.name, @transaction.hash, 'Transaction'
    meta_description "Transaction #{@transaction.hash} - #{@chain.network_name} - #{@chain.name}"

    respond_to do |format|
      format.html
      format.json { render json: { transaction: @transaction } }
    end
  end
end
