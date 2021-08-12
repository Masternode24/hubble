class Prime::Accounts::Cosmos < Prime::Account
  def details
    @details ||= ::Cosmos::AccountDecorator.new(::Cosmos::Chain.find_by(slug: network.primary_chain.slug), address)
  end

  def rewards
    @rewards ||= network.primary_chain.client.prime_rewards(self)
  end
end
