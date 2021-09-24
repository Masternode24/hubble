class Prime::Accounts::Oasis < Prime::Account
  def details
    @details ||= network.primary_chain.client.account(address, retrieve_delegations: true)
  end

  def rewards(start_time, end_time)
    @rewards ||= network.primary_chain.client.prime_rewards(self, start_time, end_time)
  end
end
