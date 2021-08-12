module Celo
  class EventFactory
    EVENT_KIND_CLASSES = {
      joined_active_set: Common::IndexerEvent::ActiveSetInclusion,
      left_active_set: Common::IndexerEvent::ActiveSetInclusion,
      missed_n_consecutive: Common::IndexerEvent::NConsecutive,
      missed_n_of_m: Common::IndexerEvent::NOfM,
      group_reward_change_1: Common::IndexerEvent::RewardCutChange,
      group_reward_change_2: Common::IndexerEvent::RewardCutChange,
      group_reward_change_3: Common::IndexerEvent::RewardCutChange
    }.with_indifferent_access.freeze

    def self.generate(attrs, chain)
      EVENT_KIND_CLASSES[attrs['kind']].new(attrs, chain)
    end
  end
end
