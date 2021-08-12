module Avalanche
  class EventFactory
    EVENT_KIND_CLASSES = {
      validator_added: Common::IndexerEvent::ValidatorAdded,
      validator_finished: Common::IndexerEvent::ValidatorFinished,
      delegator_added: Common::IndexerEvent::DelegatorAdded,
      delegator_finished: Common::IndexerEvent::DelegatorFinished,
      validator_commission_changed: Common::IndexerEvent::ValidatorCommissionChanged
    }.with_indifferent_access.freeze

    def self.generate(attrs, chain, validator_id)
      attrs['validator_name'] = validator_id
      attrs['time'] = attrs['timestamp']
      attrs['height'] = attrs['block_height']
      attrs['kind'] = attrs['type']
      EVENT_KIND_CLASSES[attrs['type']].new(attrs, chain)
    end
  end
end
