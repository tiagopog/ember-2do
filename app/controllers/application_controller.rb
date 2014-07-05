class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :authenticate

  protected

  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    # Note (Tiago): I usually use Redis and an extra ApiKey model to manage 
    # user access tokens, but for sample purposes I will keep a very simple
    # auth strategy here.
    @current_user ||= User.find_by(token: params[:token]) unless params[:token].nil?
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: { message: 'Bad credentials' }, status: 401
  end    
end
