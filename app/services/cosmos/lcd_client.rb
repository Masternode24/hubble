class Cosmos::LcdClient < Common::LcdClient
  def account(address)
    get("/cosmos/auth/v1beta1/accounts/#{address}")
  end

  def total_supply(token)
    get("/cosmos/bank/v1beta1/supply/#{token}")['amount']['amount'].to_f
  end

  def reported_blocks_per_year
    get('cosmos/mint/v1beta1/params')['params']['blocks_per_year'].to_f
  end

  def reported_inflation
    get('/cosmos/mint/v1beta1/inflation')['inflation'].to_f
  end

  def community_tax
    get('/cosmos/distribution/v1beta1/params')['params']['community_tax'].to_f
  end

  def accrued_rewards(validator_address)
    get("/cosmos/distribution/v1beta1/delegators/#{validator_address}/rewards")
  end
end
