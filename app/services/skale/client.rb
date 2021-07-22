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
      Skale::Validator.new(get("/validators/#{id}").first)
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

    def events(current_page, opts = {})
      opts.merge!(pagination(current_page))
      get_collection(Skale::Event, '/system_events', opts)
    end

    def pagination(current_page)
      if !current_page.nil? && current_page > 1
        { limit: PAGE_LIMIT, offset: (PAGE_LIMIT * (current_page - 1)) }
      else
        { limit: PAGE_LIMIT, offset: 0 }
      end
    end
  end
end
