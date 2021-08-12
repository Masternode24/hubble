class Common::IndexerEvent::ActiveSetInclusion < Common::IndexerEvent
  def initialize(event, chain)
    super(event, chain)
    if (event['kind'] == 'joined_active_set') || (event['kind'] == 'joined_set')
      @data = { 'status' => 'added' }
      @icon_name = 'link'
    else
      @data = { 'status' => 'removed' }
      @icon_name = 'unlink'
    end
  end

  def positive?
    data['status'] == 'added'
  end
end
