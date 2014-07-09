class ApplicationController < ActionController::Base
  rescue_from Exception, with: :error_render_method
  protect_from_forgery with: :null_session
  helper_method :authenticate, :json

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
    render json: { message: 'Unauthorized request' }, status: 401
  end

  def error_render_method
    json({ message: 'Bad request' }, 400)
  end
end
