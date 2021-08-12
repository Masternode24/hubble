module Avalanche
  class Event < Common::Resource
    field :id
    field :type, type: :string
    field :block_height, type: :integer
    field :timestamp, type: :timestamp
    field :item_id, type: :string
    field :tx_hash, type: :string
    collection :data
  end
end
