class Prime::Cosmos::ValidatorDecorator < Prime::ValidatorDecorator
  def network_name
    'Cosmos'
  end

  def uptime_as_percentage
    current_uptime * 100
  end

  def validator_events!
    @validator_events ||= Cosmos::Chain.primary.validators.find_by(address: address).events.sort_by(&:time).reverse.map do |event|
      Prime::ValidatorEventDecorator.new(event, event.chainlike.prime_primary_chain)
    end
  end

  def factored_commission
    info['commission']['commission_rates']['rate'].to_f * 100
  end
end
