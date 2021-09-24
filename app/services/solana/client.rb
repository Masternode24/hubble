module Solana
  class Client < Common::IndexerClient
    DEFAULT_TIMEOUT = 30

    def current_epoch
      make_request('getEpochInfo')['result']['epoch']
    end

    def block_time(height)
      make_request('getBlockTime', [height])['result']
    end

    def total_supply
      make_request('getSupply')['result']['value']['total'].to_f
    end

    def total_delegated_tokens
      votes.sum { |vote| vote['activatedStake'] }
    end

    def validator_delegated_tokens(address)
      votes.select { |vote| vote['votePubkey'] == address }.first['activatedStake'].to_f
    end

    def reported_inflation
      make_request('getInflationRate')['result']['total']
    end

    def commission_rate(validator, epoch)
      rewards([validator], epoch)[0]['commission'].to_f / 100
    end

    def rewards(addresses, epoch)
      params = [addresses, { 'epoch': epoch }]
      make_request('getInflationReward', params)['result']
    end

    private

    def make_request(method, params = nil)
      body = { 'jsonrpc': '2.0', 'id': 1, 'method': method, 'params': params }.to_json
      post(content_type: 'application/json', body: body)
    end

    def votes
      make_request('getVoteAccounts')['result']['current']
    end
  end
end
