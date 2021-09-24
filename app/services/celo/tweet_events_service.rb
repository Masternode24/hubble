class Celo::TweetEventsService
  DEFAULT_TWEET_LIMIT = 1.minute.freeze

  def initialize(chain, client = nil)
    @chain = chain
    @client = client
  end

  def call
    return unless chain.has_twitter_config?

    chain.client.paginated_events(chain).records.
      select { |event| tweet_event?(event) }.
      sort_by(&:time).
      each { |event| handle_event(event) }
  end

  private

  attr_reader :chain

  def handle_event(event)
    tweet(message(event))
    chain.update(last_event_tweet_at: event.time) if tweet_event?(event)
  end

  def tweet(message)
    if Rails.env.production?
      client.update(message)
    else
      puts message
    end
  end

  def message(event)
    "#{event.twitter_message} - #{Router.new.namespaced_path('validator', event.validatorlike, chain: event.chain, full: true)}"
  end

  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key = twitter_config['consumer_key']
      config.consumer_secret = twitter_config['consumer_secret']
      config.access_token = twitter_config['access_token']
      config.access_token_secret = twitter_config['access_secret']
    end
  end

  def twitter_config
    @twitter_config ||= chain.twitter_events_config
  end

  def tweet_event?(event)
    event.time > (chain.last_event_tweet_at || DEFAULT_TWEET_LIMIT.ago)
  end
end
