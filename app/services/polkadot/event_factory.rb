module Polkadot
  class EventFactory
    EVENT_KIND_CLASSES = {
      joined_set: Common::IndexerEvent::ActiveSetInclusion,
      left_set: Common::IndexerEvent::ActiveSetInclusion,
      active_balance_change_1: Common::IndexerEvent::VotingPowerChange,
      active_balance_change_2: Common::IndexerEvent::VotingPowerChange,
      active_balance_change_3: Common::IndexerEvent::VotingPowerChange,
      delegation_joined: Common::IndexerEvent::DelegationChange,
      delegation_left: Common::IndexerEvent::DelegationChange,
      missed_n_consecutive: Common::IndexerEvent::NConsecutive,
      missed_n_of_m: Common::IndexerEvent::NOfM,
      commission_change_1: Common::IndexerEvent::RewardCutChange,
      commission_change_2: Common::IndexerEvent::RewardCutChange,
      commission_change_3: Common::IndexerEvent::RewardCutChange
    }.with_indifferent_access.freeze

    class << self
      def generate(attrs, chain)
        if attrs['data']
          attrs['data'].merge({ 'actor' => attrs['actor'] })
        else
          attrs['data'] = { 'actor' => attrs['actor'] }
        end
        EVENT_KIND_CLASSES[attrs['kind']].new(attrs, chain)
      end

      def event_kinds
        EVENT_KIND_CLASSES.keys
      end

      def event_classes
        EVENT_KIND_CLASSES.values.uniq
      end
    end
  end
end
