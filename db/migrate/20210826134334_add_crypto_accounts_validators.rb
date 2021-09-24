class AddCryptoAccountsValidators < ActiveRecord::Migration[5.2]
  def change
    create_table "crypto_accounts", force: :cascade do |t|
      t.string "address"
      t.bigint "chain_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.bigint "validator_id"
      t.index ["address"], name: "index_crypto_accounts_on_address"
      t.index ["chain_id"], name: "index_crypto_account_on_chain"
    end

    create_table "crypto_validators", force: :cascade do |t|
      t.bigint "chain_id"
      t.string "address", null: false
      t.decimal "current_voting_power", default: "0.0"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.bigint "latest_block_height"
      t.jsonb "info", default: {}
      t.datetime "first_seen_at"
      t.bigint "total_precommits", default: 0
      t.decimal "current_uptime", default: "0.0"
      t.bigint "total_proposals", default: 0
      t.datetime "last_updated"
      t.string "owner"
      t.string "moniker"
      t.index ["address"], name: "index_crypto_v_on_addr"
      t.index ["chain_id", "address"], name: "index_crypto_v_on_c__addr", unique: true
      t.index ["chain_id"], name: "index_crypto_v_on_c"
    end

    add_foreign_key "crypto_validators", "crypto_chains", column: "chain_id"
  end
end
