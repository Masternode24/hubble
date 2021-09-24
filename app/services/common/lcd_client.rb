class Common::LcdClient < Common::Client
  private

  def request(path, req_method, params = {}, body = {}, content_type = nil)
    super(path, req_method, params, body, content_type)
  rescue Common::Client::Error
    raise Common::LcdClient::Error
  rescue Common::Client::NotFoundError
    raise Common::LcdClient::NotFoundError
  end
end
