class Prime::Chains::Celo < Prime::Chain
  def client
    @client ||= ::Celo::Client.new(api_url)
  end
end
