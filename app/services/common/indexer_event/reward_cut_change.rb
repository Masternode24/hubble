class Common::IndexerEvent::RewardCutChange < Common::IndexerEvent
  def initialize(event, chain)
    super(event, chain)
    @icon_name = 'percentage'
    @from = event['data']['before'].to_f / 1000
    @to = event['data']['after'].to_f / 1000
  end

  def positive?
    to > from
  end
end
