class Common::IndexerEvent::Kicked < Common::IndexerEvent
  def initialize(event, chain)
    super(event, chain)
    @icon_name = 'removed'
    @reason = event['metadata']['reason']
    @data = { 'reason' => event['metadata']['reason'] }
  end
end
