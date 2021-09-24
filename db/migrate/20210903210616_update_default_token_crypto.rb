class UpdateDefaultTokenCrypto < ActiveRecord::Migration[5.2]
  def change
    change_column_default :crypto_chains, :token_denom, from: "atom", to: "cro"
  end
end
