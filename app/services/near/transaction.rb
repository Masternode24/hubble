module Near
  class Transaction < Common::Resource
    field :id
    field :time
    field :height
    field :hash
    field :sender
    field :receiver
    field :gas_burnt, type: :integer
    field :success
    field :fee, type: :integer
    collection :actions
  end
end
