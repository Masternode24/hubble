class Common::IndexerEvent::NOfM < Common::IndexerEvent
  def initialize(event, chain)
    super(event, chain)
    @icon_name = 'exclamation-circle'
    @data['n'] = event['data']['threshold']
    @data['m'] = event['data']['max_validator_sequences']
  end

  def positive?
    false
  end

  def twitter_message
    "#{validatorlike_short_name} missed #{n} of #{m} precommits as of block #{height}"
  end
end
