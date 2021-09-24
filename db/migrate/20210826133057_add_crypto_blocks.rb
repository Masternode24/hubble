class AddCryptoBlocks < ActiveRecord::Migration[5.2]
  def change
    create_table "crypto_blocks", force: :cascade do |t|
      t.bigint "chain_id"
      t.string "id_hash", null: false
      t.bigint "height", null: false
      t.datetime "timestamp", null: false
      t.string "precommitters", default: [], array: true
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.jsonb "validator_set", default: {}
      t.string "proposer_address"
      t.string "transactions", array: true
      t.index ["chain_id", "height", "timestamp"], name: "index_crypto_b_on_c__h__t"
      t.index ["chain_id", "height"], name: "index_crypto_b_on_c__h", unique: true
      t.index ["chain_id", "id_hash"], name: "index_crypto_b_on_hash", unique: true
      t.index ["precommitters"], name: "index_crypto_b_on_pc", using: :gin
    end

    add_foreign_key "crypto_blocks", "crypto_chains", column: "chain_id"
  end
end
