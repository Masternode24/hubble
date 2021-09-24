module Skale
  class Client < Common::IndexerClient
    DEFAULT_TIMEOUT = 5
    PAGE_LIMIT = 50

    def status
      @status ||= Skale::Status.new(get('/health'))
    rescue Common::IndexerClient::Error
      Skale::Status.failed
    end

    def validators(opts = {})
      get_collection(Skale::Validator, '/validators', opts)
    end

    def validators_count
      Rails.cache.fetch([self.class.name, 'validators_count'].join('-'), expires_in: MEDIUM_EXPIRY_TIME) do
        validators.count(&:authorized)
      end
    end

    def validator(id)
      Rails.cache.fetch([self.class.name, 'validator', id].join('-'), expires_in: SHORT_EXPIRY_TIME) do
        Skale::Validator.new(get("/validators/#{id}").first)
      end
    end

    def delegations(opts = {})
      get_collection(Skale::Delegation, '/delegations', opts)
    end

    def nodes(opts = {})
      get_collection(Skale::Node, '/nodes', opts)
    end

    def staked_over_time(opts = {})
      get_collection(Skale::ValidatorStatistics, '/validators/statistics', opts)
    end

    def delegation_summary(opts = {})
      data = get('/summary', opts)['delegation_summary'] || []
      data.map { |n| Skale::DelegationSummary.new(n) }
    end

    def node(opts)
      Skale::Node.new(get('/nodes', opts).first)
    end

    def accounts(opts = {})
      get_collection(Skale::Account, '/accounts', opts)
    end

    def event(opts = {})
      get_collection(Skale::Event, '/system_events', opts)
    end

    def events(current_page, opts, page_limit: nil)
      opts.merge!(pagination(current_page, page_limit || PAGE_LIMIT))
      get_collection(Skale::Event, '/system_events', opts)
    end

    def pagination(current_page, page_limit)
      if !current_page.nil? && current_page > 1
        { limit: page_limit, offset: (page_limit * (current_page - 1)) }
      else
        { limit: page_limit, offset: 0 }
      end
    end

    ## Event Subscriptions
    def validator_events(chain:, address:, after_block: nil, start_time: nil, end_time: nil, kind_class: nil)
      events_list = fetch_events(address, after_block, start_time)
      all_events = events_list.map { |event| Skale::EventFactory.generate(event, chain, address) }
      all_events.select! { |event| event.kind == kind_class } if kind_class.present?
      all_events.select! { |event| event.time >= start_time } if start_time.present?
      all_events.select! { |event| event.time <= end_time } if end_time.present?
      all_events.sort_by(&:timestamp).reverse
    end

    def fetch_events(address, after_block, _start_time)
      Rails.cache.fetch([self.class.name, address, after_block, 'fetch_events'].join('-'), expires_in: SHORT_EXPIRY_TIME) do
        get('/system_events', { after: after_block, validator_id: address }) || []
      end
    end

    def get_alertable_name(address)
      address
    end
  end
end
