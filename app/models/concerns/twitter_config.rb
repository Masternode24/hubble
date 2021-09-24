module TwitterConfig
  TWITTER_CONFIG_FIELDS = %w[consumer_key consumer_secret access_token access_secret].freeze

  def has_twitter_config?
    TWITTER_CONFIG_FIELDS.all? do |field|
      !twitter_events_config[field].nil?
    end
  end
end
