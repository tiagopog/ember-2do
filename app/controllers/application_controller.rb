class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  rescue_from Exception, with: :error_render_method
  helper_method :authenticate, :json, :http_error_msg

  protected

  def json(data, status)
    render json: data, status: status
  end

  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_with_http_token do |token, options|
      @current_user ||= Session.authenticate(token)
    end
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: { message: http_error_msg[401] }, status: 401
  end

  def error_render_method
    json({ message: http_error_msg[400] }, 400)
  end

  def http_error_msg
    { 400 => 'Bad request',
      401 => 'Unauthorized request', 
      404 => 'Not found',
      422 => 'Unprocessable entity' }
  end
end
