module Near
  class Client < Common::IndexerClient
    DEFAULT_REWARDS_REQUEST_LENGTH = 90.days
    DEFAULT_TIMEOUT = 5
    # Get current service status
    def status
      Near::Status.new(get('/status'))
    end

    # Get current chain height
    def current_height
      get('/height')['height']
    end

    # Get the most recent block
    def current_block
      Near::Block.new(get('/block'))
    rescue Common::IndexerClient::NotFoundError
      nil
    end

    # Get block by hash or height
    def block(id)
      Near::Block.new(get("/blocks/#{id}"))
    rescue Common::IndexerClient::NotFoundError
      nil
    end

    alias block_by_hash block
    alias block_by_height block

    # Get block average times
    def block_times(limit = 100)
      Near::BlockTime.new(get('/block_times', limit: limit))
    end

    # Get block stats for a given time interval
    def block_stats_charts(opts = {})
      get_collection(Near::BlockStat, '/block_stats', opts)
    end

    def block_stats(period: '48', interval: 'h')
      get_collection(Near::BlockStat, '/block_stats', limit: period, bucket: interval)
    end

    def paginate(resource_class, path, opts = {})
      Near::PaginatedResponse.new(resource_class, get(path, opts))

      # currently the indexer timeouts here due to the way it calculates counts.
      # this is a WIP and hopefully will be fixed in future but using
      # limit/pagination won't fix it as it still does a count over the whole table
    rescue Common::IndexerClient::Timeout
      nil
    end

    def transaction(id)
      Near::Transaction.new(get("/transactions/#{id}"))
    end

    # Get validators
    def validators
      get_collection(Near::Validator, '/validators')
    end

    # Get validator by hash or height
    def validator(id, network: nil)
      data = get("/validators/#{id}")

      data['validator'].merge!(
        'account': data['account'],
        'epochs': data['epochs'],
        'blocks': data['blocks']
      )
      Near::Validator.new(data['validator'], network)
    end

    alias validator_by_height validator

    # Get account by name
    def account(id)
      Near::Account.new(get("/accounts/#{id}").merge('id' => id))
    end

    def prime_rewards(prime_account)
      Rails.cache.fetch([self.class.name, 'rewards', prime_account.address].join('-'), expires_in: MEDIUM_EXPIRY_TIME) do
        token_factor = prime_account.network.primary_chain.reward_token_factor
        token_display = prime_account.network.primary_chain.reward_token_display
        start_time = (Time.now.utc - DEFAULT_REWARDS_REQUEST_LENGTH).strftime('%Y-%m-%d')
        end_time = Time.now.utc.strftime('%Y-%m-%d')
        list = get("/delegators/#{prime_account.address}/rewards", from: start_time, to: end_time, interval: 'daily') || []
        list.map do |reward|
          Prime::Reward::Near.new(reward, prime_account, token_factor: token_factor, token_display: token_display)
        end
      end
    end

    def delegations(id)
      get_collection(Near::Delegation, "/delegations/#{id}")

      # currently the indexer timeouts here due to the way it calculates counts.
      # this is a WIP and hopefully will be fixed in future but using
      # limit/pagination won't fix it as it still does a count over the whole table
    rescue Common::IndexerClient::Timeout
      nil
    end

    def event(id)
      Near::Event.new(get("/events/#{id}"))
    end

    # Events subscriptions
    def validator_events(chain, validator_name, start_block = nil)
      params = { "item_id": validator_name, "item_type": 'validator', "height": start_block }
      events_list = get('/events', params)['records'] | []
      events_list.map { |event| Near::EventFactory.generate(event, chain, validator_name) }
    end

    def get_recent_events(chain, address, klass, time_ago)
      all_events = validator_events(chain, address)
      all_events.select { |e| e.created_at >= time_ago && e.kind == klass }
    end

    def get_alertable_name(address)
      address
    end

    def get_events_for_alert(chain, subscription, seconds_ago, date = nil)
      all_events = retrieve_events(chain, subscription.alertable.address, seconds_ago)

      # filter out events prior to last alert time
      if !date
        filtered_events = all_events.select { |e| e.time > subscription.last_instant_at }
      else
        filtered_events = all_events.select do |e|
          e.time >= date.beginning_of_day && e.time <= date.end_of_day
        end
      end
    end

    private

    def retrieve_events(chain, address, seconds_ago)
      # get events from twice the supplied timeframe to ensure all unsent events are picked up
      blocks_back = (seconds_ago * 2) / block_times(1000).avg
      start_block = (current_block.id - blocks_back).round.to_i

      validator_events(chain, address, start_block)
    end
  end
end
