class AddOtpSecretKeyToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :otp_secret_key, :string
    add_column :users, :otp_enabled, :boolean, null: false, default: false
    add_column :users, :otp_enabled_at, :timestamp
  end

  def down
    remove_column :users, :otp_secret_key
    remove_column :users, :otp_enabled
    remove_column :users, :otp_enabled_at
  end
end
