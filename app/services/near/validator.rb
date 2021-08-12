module Near
  class Validator < Common::Resource
    include NearHelper

    STATUS_ONLINE  = 'online'.freeze
    STATUS_OFFLINE = 'offline'.freeze

    field :id
    field :account_id
    field :start_height
    field :start_time, type: :timestamp
    field :last_height
    field :last_time, type: :timestamp
    field :height
    field :time
    field :expected_blocks
    field :produced_blocks
    field :slashed
    field :active
    field :stake, type: :integer
    field :efficiency
    field :epoch
    field :created_at
    field :updated_at
    field :reward_fee, type: :integer
    field :address
    field :network, type: Prime::Network

    alias address account_id
    # Associated resources
    field :epochs
    field :account
    field :blocks

    def initialize(attrs = {}, network = nil)
      super(attrs)
      @account = Account.new(attrs[:account])                    if attrs[:account]
      @epochs = attrs[:epochs].map { |r| ValidatorEpoch.new(r) } if attrs[:epochs]
      @blocks = attrs[:blocks].map { |r| Block.new(r) }          if attrs[:blocks]
      @network = network if network
    end

    def active?
      !!@active
    end

    def status
      active? ? STATUS_ONLINE : STATUS_OFFLINE
    end
  end
end
