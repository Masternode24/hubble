class Common::Event::Kicked < Common::Event
  def initialize(event, chain)
    super(event, chain)
    @icon_name = 'removed'
    @reason = event['metadata']['reason']
  end
end
