class Prime::AccountsController < Prime::ApplicationController
  before_action :require_network, except: %i[index update destroy]

  def index
    @new_account = Prime::Account.new
  rescue Prime::MessariDataService::Error
    flash[:error] = 'Sorry, Prime is unavailable but we are working on restoring service.'
    redirect_to root_path
  end

  def create
    unless account_valid?
      flash[:error] = 'That does not appear to be a valid address.'
      return redirect_to prime_root_path
    end

    @account = Prime::Account.new(create_account_params)

    if @account.save
      flash[:success] = 'Account added successfully!'
      redirect_to prime_root_path
    else
      flash[:error] = "We were unable to add that account. #{@account.errors.messages[:address].first}"
      redirect_to prime_root_path
    end
  end

  def update
    @account = Prime::Account.find_by(id: params[:id])
    if @account.update(update_account_params)
      flash[:success] = 'Account name has been updated!'
      redirect_to prime_accounts_path
    else
      flash[:error] = 'Account name could not be updated!'
      redirect_to prime_accounts_path
    end
  end

  def destroy
    Prime::Account.find_by(id: params[:id]).destroy

    flash[:success] = 'Address deleted from your portfolio.'
    redirect_to prime_accounts_path
  end

  private

  def create_account_params
    params[:prime_account][:type] = "Prime::Accounts::#{@network.name.capitalize}"

    params.require(:prime_account).permit(:prime_network_id,
                                          :user_id,
                                          :type,
                                          :address,
                                          :name)
  end

  def update_account_params
    params[:update].permit(:prime_network_id,
                           :user_id,
                           :type,
                           :address,
                           :name)
  end

  def require_network
    @network = Prime::Network.find_by!(id: params[:prime_account][:prime_network_id])
  end

  def account_valid?
    @network.primary_chain.account_valid?(params[:prime_account][:address])
  rescue Common::IndexerClient::Error, Common::LcdClient::Error => e
    flash[:error] = 'That does not appear to be a valid address.'
    false
  end
end
