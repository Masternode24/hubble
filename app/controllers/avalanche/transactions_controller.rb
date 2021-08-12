class Avalanche::TransactionsController < Avalanche::BaseController
  before_action :init_search_form, only: :index
  before_action :load_assets
  before_action :load_blockchains, only: :show

  def index
    @result = client.transactions(@search_form.to_hash)
    @transactions = @result.data

    if request.xhr?
      render partial: 'avalanche/transactions/index/table', locals: { transactions: @transactions }
      return
    end

    page_title 'Transaction Search'
  rescue Common::IndexerClient::Error => err
    flash[:error] = "Search request failed: #{err.message}"
    @transactions = []
  end

  def show
    @transaction = client.transaction(params[:id])
  end

  private

  def load_assets
    @assets = client.assets.index_by(&:id)
  end

  def load_blockchains
    @blockchains = client.blockchains.index_by(&:id)
  end

  def init_search_form
    @search_form = Avalanche::TransactionSearch.new(search_params.to_hash)
    if request.xhr?
      @search_form.page = @search_form.page + 1
    else
      @search_form.page
    end
  end

  def search_params
    scope = params
    scope = params.require(:search) if params[:search].present?

    scope.permit(
      :chain,
      :account,
      :start_time,
      :end_time,
      :memo,
      :show,
      type: []
    )
  end
end
