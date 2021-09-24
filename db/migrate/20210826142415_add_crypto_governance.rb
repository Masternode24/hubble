class AddCryptoGovernance < ActiveRecord::Migration[5.2]
  def change
    create_table "crypto_governance_deposits", force: :cascade do |t|
      t.bigint "account_id"
      t.bigint "proposal_id"
      t.string "amount_denom"
      t.bigint "amount"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["account_id"], name: "index_crypto_deposit_on_account"
      t.index ["proposal_id"], name: "index_crypto_deposit_on_proposal"
    end

    create_table "crypto_governance_proposals", force: :cascade do |t|
      t.bigint "chain_id"
      t.bigint "ext_id"
      t.string "title"
      t.text "description"
      t.string "proposal_type"
      t.string "proposal_status"
      t.decimal "tally_result_yes"
      t.decimal "tally_result_abstain"
      t.decimal "tally_result_no"
      t.decimal "tally_result_nowithveto"
      t.datetime "submit_time"
      t.jsonb "total_deposit", default: {}
      t.datetime "voting_start_time"
      t.datetime "voting_end_time"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.datetime "deposit_end_time"
      t.json "additional_data"
      t.boolean "finalized", default: false
      t.index ["chain_id", "ext_id"], name: "index_crypto_governance_proposals_on_chain_and_cp_id", unique: true
      t.index ["chain_id"], name: "index_crypto_proposal_on_chain"
      t.index ["ext_id"], name: "index_crypto_governance_proposals_on_ext_id"
      t.index ["proposal_status"], name: "index_crypto_governance_proposals_on_proposal_status"
      t.index ["proposal_type"], name: "index_crypto_governance_proposals_on_proposal_type"
      t.index ["submit_time"], name: "index_crypto_governance_proposals_on_submit_time"
      t.index ["voting_end_time"], name: "index_crypto_governance_proposals_on_voting_end_time"
      t.index ["voting_start_time"], name: "index_crypto_governance_proposals_on_voting_start_time"
    end

    create_table "crypto_governance_votes", force: :cascade do |t|
      t.bigint "account_id"
      t.bigint "proposal_id"
      t.string "option"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["account_id"], name: "index_crypto_vote_on_account"
      t.index ["proposal_id"], name: "index_crypto_vote_on_proposal"
    end
  end
end
