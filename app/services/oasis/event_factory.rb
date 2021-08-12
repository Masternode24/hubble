module Oasis
  class EventFactory
    EVENT_KIND_CLASSES = {
      joined_active_set: Common::IndexerEvent::ActiveSetInclusion,
      left_active_set: Common::IndexerEvent::ActiveSetInclusion,
      active_escrow_balance_change_1: Common::IndexerEvent::VotingPowerChange,
      active_escrow_balance_change_2: Common::IndexerEvent::VotingPowerChange,
      active_escrow_balance_change_3: Common::IndexerEvent::VotingPowerChange,
      missed_n_consecutive: Common::IndexerEvent::NConsecutive,
      missed_n_of_m: Common::IndexerEvent::NOfM,
      commission_change_1: Common::IndexerEvent::RewardCutChange,
      commission_change_2: Common::IndexerEvent::RewardCutChange,
      commission_change_3: Common::IndexerEvent::RewardCutChange
    }.with_indifferent_access.freeze

    def self.generate(attrs, chain)
      EVENT_KIND_CLASSES[attrs['kind']].new(attrs, chain)
    end
  end
end
