class Api::BaseController < ActionController::Base

  before_action :verify_access?, :header

  attr_reader :current_user

  def verify_access?
    request.env['HTTP_API_TOKEN'] =~ /^Token\s(.*)$/
    token = $1
    @current_user = User.find_by(api_token: token)
  rescue StandardError => ex
    send_error_response(401, ex, nothing: true)
  end

  def header
    response['HTTP_API_TOKEN'] = "Token #{current_user.api_token}" and return if current_user
    response['HTTP_API_TOKEN'] = ""
  end

  def send_error_response(status, ex, **res)
    response['APP_ERROR'] = "#{ex.message} -- #{ex.backtrace.first}"
    render res.merge(status: status)
  end

  def send_response_with_token(status, token, **res)
    response['HTTP_API_TOKEN'] = "Token #{token}"
    render res.merge(status: status)
  end

end