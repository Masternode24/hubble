class AddEthStakingEnabledToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :prime_eth_staking_enabled, :boolean, null: false, default: false
  end
end