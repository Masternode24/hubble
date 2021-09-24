module Prime::Admin::Eth2Staking
  class CustomersController < BaseController
    def index
      @customers = anjin_client.customers
    end

    def show
      @customer = anjin_client.customer(params[:id])
      @staking_positions = anjin_client.staking_positions(customer_id: @customer.id)
      @validators = @staking_positions.flat_map(&:validators)
      @associated_users = User.where(prime_eth_staking_customer_id: @customer.id)
    rescue Common::Client::NotFoundError => err
      flash[:error] = 'Customer was not found'
      redirect_to prime_admin_eth2_staking_customers_path
    end
  end
end
