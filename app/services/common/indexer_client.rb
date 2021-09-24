class Common::IndexerClient < Common::Client
  LONG_EXPIRY_TIME = 1.day
  MEDIUM_EXPIRY_TIME = 1.hour
  SHORT_EXPIRY_TIME = 15.minutes
  DEFAULT_LATEST_HEIGHT = 0

  def get_collection(class_name, path, params = {})
    get(path, params).map { |record| class_name.new(record) }
  end

  def post(path = nil, params = {}, body: {}, content_type: nil)
    request(path, :post, params, body, content_type)
  end

  private

  def request(path, req_method, params = {}, body = {}, content_type = nil)
    super(path, req_method, params, body, content_type)
  rescue Common::Client::NotFoundError => err
    # in general we shouldn't log these to error, but indexers very rarely return 404
    # so let's have an eye on it
    Rails.logger.error(err)
    raise Common::IndexerClient::NotFoundError, err
  rescue Common::Client::Error => err
    raise Common::IndexerClient::Error, err
  end
end
