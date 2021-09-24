class Prime::Chains::Solana < Prime::Chain
  def client
    @client ||= ::Solana::Client.new(api_url)
  end
end
