module Avalanche
  class TransactionOutput < Common::Resource
    field :id
    field :tx_id
    field :chain
    field :type
    field :asset
    field :index
    field :amount
    field :spent
    field :spent_in_tx
    field :stake
    field :reward
    field :addresses
    field :locktime
  end
end
