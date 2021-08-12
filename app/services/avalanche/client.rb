module Avalanche
  class Client < Common::IndexerClient
    PAGE_LIMIT = 20

    def status
      @status ||= Avalanche::Status.new(get('/status'))
    rescue Common::IndexerClient::Error
      Avalanche::Status.failed
    end

    def validators(opts = {})
      get_collection(Avalanche::Validator, '/validators', opts)
    end

    def validator(id)
      Avalanche::ValidatorDetails.new(get("/validators/#{id}").merge('address' => id))
    end

    def network_stats(opts = {})
      get_collection(Avalanche::NetworkStat, '/network_stats', opts)
    end

    def validators_stake(opts = {})
      total_delegated(opts)
    end

    def validator_hourly_uptime_avg(node_id)
      validators_hourly_uptime_avg(node_id)
    end

    def validators_count
      Rails.cache.fetch([self.class.name, 'validators_count'].join('-'), expires_in: MEDIUM_EXPIRY_TIME) do
        network_stats(bucket: 'h', limit: 1)[0].active_validators
      end
    end

    def total_delegated(opts = {})
      get('/network_stats', opts).reverse.map { |n| Avalanche::ValidatorSummary.new(n) }
    end

    def validators_hourly_uptime_avg(node_id)
      data = get("/validators/#{node_id}")
      data.stats_24h.map { |n| Avalanche::ValidatorStat.new(n) }
    end

    def account(account)
      raw_address = get("/address/#{account}")
      Avalanche::Account.new(raw_address['P'].merge(x_chain_assets: raw_address['X']))
    end

    def delegations(opts = {})
      get_collection(Avalanche::Delegation, '/delegations', opts)
    end

    def transactions(opts = {})
      Avalanche::TransactionSearchOutput.new(get('/transactions', opts))
    end

    def transaction(id)
      Avalanche::Transaction.new(get("/transactions/#{id}"))
    end

    def assets
      Rails.cache.fetch([self.class.name, 'assets'].join('-'), expires_in: MEDIUM_EXPIRY_TIME) do
        get_collection(Avalanche::Asset, '/assets')
      end
    end

    def blockchains
      Rails.cache.fetch([self.class.name, 'chains'].join('-'), expires_in: MEDIUM_EXPIRY_TIME) do
        get_collection(Avalanche::BlockChain, '/chains')
      end
    end

    def events(current_page, opts = {})
      opts.merge!(pagination(current_page))
      get_collection(Avalanche::Event, '/events', opts)
    end

    def validator_events(chain:, address:, after_block: nil, start_time: nil, end_time: nil, kind_class: nil)
      events_list = fetch_events(address, after_block, start_time)
      all_events = events_list.map { |event| Avalanche::EventFactory.generate(event, chain, address) }
      all_events.select! { |event| event.type == kind_class } if kind_class.present?
      all_events.select! { |event| event.timestamp <= end_time } if end_time.present?
      all_events.sort_by(&:timestamp).reverse
    end

    def event(id)
      Avalanche::Event.new(get("/events/#{id}"))
    end

    def pagination(current_page)
      if !current_page.nil? && current_page > 1
        { limit: PAGE_LIMIT, offset: (PAGE_LIMIT * (current_page - 1)) }
      else
        { limit: PAGE_LIMIT, offset: 0 }
      end
    end

    def fetch_events(address, after_block, start_time)
      Rails.cache.fetch([self.class.name, address, after_block, 'fetch_events'].join('-'), expires_in: SHORT_EXPIRY_TIME) do
        get('/events', { start_height: after_block, item_id: address.gsub('NodeID-', ''), item_type: 'validator', start_time: start_time.to_datetime.rfc3339 }) || []
      end
    end

    def get_alertable_name(address)
      address
    end
  end
end
