class AddAccountNameToPrimeAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :prime_accounts, :name, :string, default: nil
  end
end
