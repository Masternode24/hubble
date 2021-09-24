class CreateApiKeys < ActiveRecord::Migration[5.2]
  def change
    create_table :api_keys do |t|
      t.belongs_to :user, null: false

      t.string :key, null: false
      t.string :scope
      t.datetime :last_used_at
      t.datetime :deactivated_at
      t.timestamps
    end

    add_index :api_keys, :key, unique: true
  end
end
