class Persistence::LcdClient < Common::LcdClient
  def account(address)
    get("/auth/accounts/#{address}")
  end
end
