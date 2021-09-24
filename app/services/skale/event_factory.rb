module Skale
  class EventFactory
    EVENT_KIND_CLASSES = {
      joined_active_set: Common::IndexerEvent::ActiveSetInclusion,
      left_active_set: Common::IndexerEvent::ActiveSetInclusion,
      slashed: Common::IndexerEvent::Slashed,
      kicked: Common::IndexerEvent::Kicked,
      forgiven: Common::IndexerEvent::Forgiven,
      new_delegation: Common::IndexerEvent::NewDelegation,
      delegation_accepted: Common::IndexerEvent::DelegationAccepted,
      delegation_rejected: Common::IndexerEvent::DelegationRejected,
      undelegation_requested: Common::IndexerEvent::UndelegationRequested
    }.with_indifferent_access.freeze

    def self.generate(attrs, chain, validator_id)
      attrs['validator_name'] = validator_id
      attrs['height'] = attrs['block_height']
      EVENT_KIND_CLASSES[attrs['kind']].new(attrs, chain)
    end
  end
end
