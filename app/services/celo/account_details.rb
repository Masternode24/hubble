module Celo
  class AccountDetails < Common::Resource
    field :name
    field :address
    field :metadata_url
    field :type
    collection :operations, type: Celo::Operation
    collection :transactions, type: Celo::Transaction

    def self.failed(address)
      new(name: address)
    end

    def transfers
      operations.select(&:transfer?)
    end

    def has_owner?
      type.present?
    end

    def display_name
      name.presence || address
    end
  end
end
