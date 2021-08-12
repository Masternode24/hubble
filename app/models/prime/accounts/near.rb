class Prime::Accounts::Near < Prime::Account
  def details
    @details ||= network.primary_chain.client.account(address)
  end

  def rewards
    @rewards ||= network.primary_chain.client.prime_rewards(self)
  end
end
