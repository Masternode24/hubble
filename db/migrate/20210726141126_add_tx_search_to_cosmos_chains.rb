class AddTxSearchToCosmosChains < ActiveRecord::Migration[5.2]
  def change
    add_column :cosmos_chains, :tx_search_url, :string
    add_column :cosmos_chains, :tx_search_enabled, :boolean, default: false
  end
end
