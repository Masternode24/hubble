class AddCryptoChains < ActiveRecord::Migration[5.2]
  def change
    create_table "crypto_chains" do |t|
      t.string "name", null: false
      t.boolean "testnet", null: false
      t.bigint "history_height", default: 0
      t.datetime "last_sync_time"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.boolean "primary", default: false
      t.string "slug", null: false
      t.string "rpc_host"
      t.integer "rpc_port"
      t.integer "lcd_port"
      t.boolean "disabled", default: false
      t.jsonb "validator_event_defs", default: [{"kind"=>"voting_power_change", "height"=>0}, {"kind"=>"active_set_inclusion", "height"=>0}]
      t.integer "failed_sync_count", default: 0
      t.jsonb "governance", default: {}, null: false
      t.datetime "halted_at"
      t.string "last_round_state", default: ""
      t.string "ext_id"
      t.string "token_denom", default: "atom"
      t.bigint "token_factor", default: 0
      t.string "sdk_version"
      t.text "notes"
      t.boolean "use_ssl_for_lcd", default: false
      t.jsonb "staking_pool", default: {}
      t.string "remote_denom"
      t.boolean "dead", default: false
      t.integer "position"
      t.integer "latest_local_height", default: 0
      t.datetime "cutoff_at"
      t.jsonb "token_map", default: {}
      t.jsonb "twitter_events_config", default: {}
      t.json "community_pool"
      t.string "lcd_host"
      t.string "rpc_path"
      t.string "lcd_path"
      t.boolean "use_ssl_for_rpc", default: false
      t.string "network"
      t.float "staking_participation"
      t.float "rewards_rate"
      t.float "daily_rewards"
      t.string "tx_search_url"
      t.boolean "tx_search_enabled", default: false
    end
  end
end
