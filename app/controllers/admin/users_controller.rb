class Admin::UsersController < Admin::BaseController
  before_action :find_user, except: %i[index]

  def index
    if params[:prime_only]
      @users = User.with_prime_access.includes(:prime_accounts)
    else
      @users = User.all.includes(:prime_accounts)
    end
  end

  def destroy
    name = @user.name
    @user.update deleted: true
    flash[:notice] = "#{name} has been deleted."
    redirect_to admin_users_path
  end

  def masq
    session[:masq] = User::MASQ_TIMEOUT.from_now.to_i
    session[:uid] = @user.id
    redirect_to root_path
  end

  def toggle_prime
    @user.toggle! :prime
    redirect_to admin_users_path
  end

  def prime_eth_staking
    return unless request.put?

    if @user.update(staking_params)
      flash[:success] = 'ETH Staking settings have been updated'
    else
      flash[:error] = 'Unable to update ETH Staking settings'
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def staking_params
    params.require(:user).permit(:prime_eth_staking_enabled, :prime_eth_staking_customer_id)
  end
end
