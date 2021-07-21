module Celo
  class EventFactory
    EVENT_KIND_CLASSES = {
      joined_active_set: Common::Event::ActiveSetInclusion,
      left_active_set: Common::Event::ActiveSetInclusion,
      missed_n_consecutive: Common::Event::NConsecutive,
      missed_n_of_m: Common::Event::NOfM,
      group_reward_change_1: Common::Event::RewardCutChange,
      group_reward_change_2: Common::Event::RewardCutChange,
      group_reward_change_3: Common::Event::RewardCutChange
    }.with_indifferent_access.freeze

    def self.generate(attrs, chain)
      EVENT_KIND_CLASSES[attrs['kind']].new(attrs, chain)
    end
  end
end
