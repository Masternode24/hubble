module Near
  class EventFactory
    EVENT_KIND_CLASSES = {
      joined_active_set: Common::Event::ActiveSetInclusion,
      left_active_set: Common::Event::ActiveSetInclusion,
      kicked: Common::Event::Kicked
    }.with_indifferent_access.freeze

    def self.generate(attrs, chain, validator_id)
      attrs['validator_name'] = validator_id
      EVENT_KIND_CLASSES[attrs['action']].new(attrs, chain)
    end
  end
end
