class CreatePrimeAnalyticsDataPoints < ActiveRecord::Migration[5.2]
  def change
    create_table :prime_analytics_data_points do |t|
      t.date :date
      t.float :total_supply
      t.float :total_delegated_tokens
      t.float :figment_delegated_tokens
      t.float :token_price
      t.belongs_to :network, foreign_key: { to_table: :prime_networks }, on_delete: :cascade

      t.timestamps
    end
  end
end
