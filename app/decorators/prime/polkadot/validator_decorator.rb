class Prime::Polkadot::ValidatorDecorator < Prime::ValidatorDecorator
  def network_name
    'Polkadot'
  end

  def uptime_as_percentage
    indexer_uptime * 100
  end

  def validator_events!
    @validator_events ||= network.primary_chain.client.validator_events(chain: network.primary_chain, address: address).map do |event|
      Prime::ValidatorEventDecorator.new(event)
    end
  end
end
