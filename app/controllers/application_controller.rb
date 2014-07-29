class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  # rescue_from Exception, with: :render_bed_request
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  protected

  def authenticate!
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_with_http_token do |token, options|
      @current_user ||= Session.authenticate(token)
    end
    @current_user = User.find(16)
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: { message: 'Unauthorized request' }, status: 401
  end

  def render_bed_request
    render json: { message: 'Bad request' }, status: 400
  end
  
  def render_not_found
    render json: { message: 'Not Found' }, status: 404 
  end
end
