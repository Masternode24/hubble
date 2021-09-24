class Prime::Chains::Mina < Prime::Chain
  FIXED_FIGMENT_COMMISSION_RATE = 0.10

  def client
    @client ||= ::Mina::Client.new(api_url)
  end

  def figment_validators
    @figment_validators ||= begin
      figment_validator_addresses.map do |address|
        validator_decorator_name.new(validators.find { |v| v.public_key == address }, network)
      end
    end
  end

  def validators
    @validators ||= Mina::Chain.primary.client.validators
  end

  private

  def validator_decorator_name
    "Prime::#{network_name}::ValidatorDecorator".constantize
  end

  def network_name
    self.class.name.split('::')[-1].constantize
  end
end
