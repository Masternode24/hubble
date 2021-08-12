module Near
  class Account < Common::Resource
    BYTE_CONVERSION_FACTOR = 19

    field :id
    field :amount, type: :integer
    field :locked, type: :integer
    field :storage_usage, type: :integer
    field :name
    field :start_height
    field :start_time, type: :timestamp
    field :last_height
    field :last_time, type: :timestamp
    field :balance, type: :integer
    field :staking_balance, type: :integer
    field :created_at, type: :timestamp
    field :updated_at, type: :timestamp

    def initialize(attr)
      super(attr)
      @balance = attr['amount']
    end

    def wallet_balance
      # this is needed to convert the storage_usage bytes to near.
      amount + (storage_usage * (10 ** BYTE_CONVERSION_FACTOR))
    end
  end
end
