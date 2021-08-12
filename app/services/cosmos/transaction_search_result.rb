module Cosmos
  class TransactionSearchResult < Cosmoslike::TransactionSearchResult
    def initialize(attrs = {})
      super(attrs)
      @chain = Cosmos::Chain.find_by(slug: attrs['chain_id'])
    end
  end
end
