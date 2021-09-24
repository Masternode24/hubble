module Skale
  class Validator < Common::Resource
    field :id, type: :integer
    field :name, type: :string
    field :description, type: :string
    field :validator_address, type: :string
    field :fee_rate, type: :integer
    field :registration_time, type: :timestamp
    field :accept_new_requests
    field :authorized
    field :active_nodes, type: :integer
    field :linked_nodes, type: :integer
    field :staked, type: :integer
    field :minimum_delegation_amount, type: :integer

    alias address id

    def display_name
      @name
    end

    def fee_rate
      @fee_rate / 10
    end

    def accepting?
      accept_new_requests == true
    end

    def active?
      @authorized && @accept_new_requests ? true : false
    end
  end
end
