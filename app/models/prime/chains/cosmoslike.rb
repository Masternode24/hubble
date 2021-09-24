class Prime::Chains::Cosmoslike < Prime::Chain
  def client
    @client ||= network_name::Client.new(api_url)
  end

  def lcd_client
    @lcd_client ||= network_name::LcdClient.new(primary_chain_lcd_url)
  end

  def figment_validators
    figment_validator_addresses.map do |address|
      validator_decorator_name.new(network_name::Chain.primary.validators.find_by(address: address), network)
    end
  end

  def account_valid?(address)
    lcd_client.account(address).present?
  end

  def primary_chain_lcd_url
    network_name::Chain.find_by(slug: network.primary.slug).lcd_url
  end

  private

  def validator_decorator_name
    "Prime::#{network_name}::ValidatorDecorator".constantize
  end

  def network_name
    self.class.name.split('::')[-1].constantize
  end
end
