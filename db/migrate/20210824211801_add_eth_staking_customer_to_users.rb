class AddEthStakingCustomerToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :prime_eth_staking_customer_id, :text
  end
end
