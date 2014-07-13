class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  rescue_from Exception, with: :error_render_method

  protected

  def authenticate!
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
    render json: { message: 'Bad request' }, status: 400
  end
end
