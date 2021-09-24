class AddRpcFieldsForPrimeChains < ActiveRecord::Migration[5.2]
  def change
    change_table :prime_chains do |t|
      t.string :rpc_host
      t.integer :rpc_port
      t.string :rpc_api_key
      t.boolean :use_ssl_for_rpc, default: true
    end
  end
end
