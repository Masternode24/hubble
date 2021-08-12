module Celo
  class Proposal < Common::Resource
    EXECUTED_STATE = 'executed'.freeze

    field :id, type: :integer
    field :recent_stage
    field :started_at, type: :timestamp
    field :started_at_height, type: :integer

    def pending?
      recent_stage != EXECUTED_STATE
    end
  end
end
