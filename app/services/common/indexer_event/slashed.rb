class Common::IndexerEvent::Slashed < Common::IndexerEvent
  def initialize(event, chain)
    super(event, chain)
    @icon_name = 'removed'
  end
end
