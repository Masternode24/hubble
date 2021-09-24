class Common::Client
  DEFAULT_TIMEOUT = 3

  class Error         < StandardError; end
  class NotFoundError < Error; end

  def initialize(endpoint, options = {})
    @endpoint      = endpoint
    @timeout       = options[:timeout] || self.class::DEFAULT_TIMEOUT
    @authorization = options[:authorization]
  end

  def get(path = nil, params = {})
    request(path, :get, params)
  end

  private

  attr_reader :endpoint, :timeout

  def request(path, req_method, params = {}, body = {}, content_type = nil)
    Rails.logger.info("#{endpoint}#{path} #{params} timeout: #{timeout}")
    headers = content_type ? { 'Content-Type' => content_type, params: params } : { params: params }

    if @authorization
      headers["Authorization"] = @authorization
    end

    resp = RestClient::Request.execute(
      method: req_method,
      url: "#{endpoint}#{path}",
      headers: headers,
      payload: body,
      timeout: timeout
    )
    JSON.parse(resp.body)
  rescue JSON::ParserError => err
    JSON.load(resp.body)
  rescue RestClient::NotFound => err
    raise Common::Client::NotFoundError, err
  rescue RestClient::ExceptionWithResponse, StandardError => err
    handle_error(err)
  end

  def handle_error(err)
    message = err
    if data = JSON.parse(err.response.body) rescue nil
      message = data['error'] if data.is_a?(Hash) && data['error']
    end

    raise Common::Client::Error, message
  end
end
