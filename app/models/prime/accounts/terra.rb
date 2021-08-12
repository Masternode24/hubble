class Prime::Accounts::Terra < Prime::Account
  def details
    @details ||= ::Terra::AccountDecorator.new(::Terra::Chain.find_by(slug: network.primary_chain.slug), address)
  end

  def rewards
    @rewards ||= network.primary_chain.client.prime_rewards(self)
  end
end
