class Prime::Chains::Near < Prime::Chain
  def client
    @client ||= ::Near::Client.new(api_url)
  end

  def figment_validators
    figment_validator_addresses.map do |address|
      Prime::Near::ValidatorDecorator.new(client.validator(address, network: network))
    end
  end
end
