class Near::AccountsController < Near::BaseController
  def show
    @account = client.account(params[:id])

    opts = {
      account: params[:id],
      page: params['transactions_page'].to_i || 1,
      limit: 20
    }

    @transactions = client.paginate(Near::Transaction, '/transactions', opts)

    page_title 'Account Details'
    meta_description 'Account Details'
  end
end
