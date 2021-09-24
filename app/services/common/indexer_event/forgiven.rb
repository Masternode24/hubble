class Common::IndexerEvent::Forgiven < Common::IndexerEvent
  def initialize(event, chain)
    super(event, chain)
    @data = { 'status' => 'added' }
    @icon_name = 'link'
  end
end
