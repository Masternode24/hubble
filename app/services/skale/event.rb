module Skale
  class Event < Common::Resource
    field :id, type: :string
    field :height, type: :integer
    field :time, type: :timestamp
    field :kind, type: :string
    field :sender_id, type: :integer
    field :recipient_id, type: :integer
    field :sender, type: :string
    field :recipient, type: :string
  end
end
