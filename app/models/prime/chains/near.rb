class Prime::Chains::Near < Prime::Chain
  FIXED_INFLATION_RATE = 0.045

  def client
    @client ||= ::Near::Client.new(api_url)
  end

  def figment_validators
    figment_validator_addresses.map do |address|
      Prime::Near::ValidatorDecorator.new(client.validator(address, network: network))
    end
  end

  def account_valid?(address)
    client.validator(address).blank? && client.account(address).present?
  rescue Common::Client::NotFoundError
    client.account(address).present?
  end
end
