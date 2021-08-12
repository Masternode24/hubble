class Prime::Accounts::Oasis < Prime::Account
  def details
    @details ||= network.primary_chain.client.account(address, retrieve_delegations: true)
  end

  def rewards
    @rewards ||= network.primary_chain.client.prime_rewards(self)
  end
end
