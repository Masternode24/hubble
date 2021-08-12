module Terra
  class TransactionSearchResult < Cosmoslike::TransactionSearchResult
    def initialize(attrs = {})
      super(attrs)
      @chain = Terra::Chain.find_by(slug: attrs['chain_id'])
    end
  end
end
