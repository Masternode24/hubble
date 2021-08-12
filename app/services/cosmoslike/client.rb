class Cosmoslike::Client < Common::IndexerClient
  def transaction_search_request(body)
    tx_list = post(body: body, content_type: 'application/json') || []

    tx_list.map do |transaction|
      namespace::TransactionSearchResult.new(transaction)
    end
  end

  private

  def namespace
    self.class.name.deconstantize.constantize
  end
end
