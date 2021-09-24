class Prime::Accounts::Near < Prime::Account
  def details
    @details ||= network.primary_chain.client.account(address)
  end

  def rewards(start_time, end_time)
    @rewards ||= network.primary_chain.client.prime_rewards(self, start_time, end_time)
  rescue Common::IndexerClient::NotFoundError
    []
  end
end
