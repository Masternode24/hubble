class Common::IndexerEvent::VotingPowerChange < Common::IndexerEvent
  def initialize(event, chain)
    super(event, chain)
    @icon_name = 'battery-half'
    @from = event['data']['before'].to_f
    @to = event['data']['after'].to_f
  end

  def positive?
    to > from
  end
end
