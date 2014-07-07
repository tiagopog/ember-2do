class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  helper_method :authenticate

  protected

  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    # TODO: store/check sessions in Redis (low priority).
    unless params[:access_token].nil?
      @current_user ||= Session.authenticate(params[:access_token])
    end
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: { message: 'Unauthorized request' }, status: 401
  end
end
