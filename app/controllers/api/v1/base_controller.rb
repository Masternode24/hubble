class Api::V1::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :require_api_key

  def invalid_route
    json_error(404, 'Invalid route')
  end

  def resource_not_found
    json_error(404, 'Resource not found')
  end

  protected

  def api_key
    @api_key ||= ApiKey.find_by(key: key_from_request)
  end

  def require_api_key
    if api_key.blank? || api_key&.deactivated?
      return json_error(401, 'Invalid API key')
    end

    api_key.touch(:last_used_at)
  end

  def current_user
    api_key&.user
  end

  def key_from_request
    key_from_header || params[:api_key]
  end

  def key_from_header
    request.headers[:authorization].to_s.split(' ').last || request.env['HTTP_X_API_KEY']
  end

  def json_error(status, message)
    render(json: { status: status, error: message }, status: status)
  end

  def json_response(data)
    render(json: data)
  end
end
