module Avalanche
  class TransactionSearchOutput < Common::Resource
    collection :data, type: Avalanche::Transaction
  end
end
