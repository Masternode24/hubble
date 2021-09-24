class AddTwitterConfigToCelo < ActiveRecord::Migration[5.2]
  def up
    add_column :celo_chains, :twitter_events_config, :jsonb, default: {}

    # We copy over twitter config from Cosmos - admin views most probably won't be necessary
    cosmos_chain = Cosmos::Chain.where.not(twitter_events_config: {}).first
    Celo::Chain.update_all(twitter_events_config: cosmos_chain.twitter_events_config) if cosmos_chain
  end

  def down
    remove_column :terra_chains, :twitter_events_config
  end
end

class Celo::Chain < ApplicationRecord; end
class Cosmos::Chain < ApplicationRecord; end
