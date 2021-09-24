class Crypto::LcdClient < Common::LcdClient
  def account(address)
    get("/cosmos/auth/v1beta1/accounts/#{address}")
  end
end
