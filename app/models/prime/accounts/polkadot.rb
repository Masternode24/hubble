class Prime::Accounts::Polkadot < Prime::Account
  def details
    @details ||= network.primary_chain.client.account_details(address)
  end

  def rewards
    @rewards ||= network.primary_chain.client.prime_rewards(self)
  end
end
