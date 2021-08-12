class Prime::Near::ValidatorDecorator < Prime::ValidatorDecorator
  def network_name
    'Near'
  end

  def uptime_as_percentage
    efficiency
  end

  def validator_events!
    @validator_events ||= network.primary_chain.client.validator_events(network.primary_chain, account_id).map do |event|
      Prime::ValidatorEventDecorator.new(event)
    end
  end

  def factored_commission
    reward_fee.to_s
  end
end
