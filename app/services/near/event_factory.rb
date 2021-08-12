module Near
  class EventFactory
    EVENT_KIND_CLASSES = {
      joined_active_set: Common::IndexerEvent::ActiveSetInclusion,
      left_active_set: Common::IndexerEvent::ActiveSetInclusion,
      kicked: Common::IndexerEvent::Kicked
    }.with_indifferent_access.freeze

    def self.generate(attrs, chain, validator_id)
      attrs['validator_name'] = validator_id
      attrs['time'] = attrs['created_at']
      attrs['height'] = attrs['block_height']
      attrs['kind'] = attrs['action']
      EVENT_KIND_CLASSES[attrs['action']].new(attrs, chain)
    end
  end
end
