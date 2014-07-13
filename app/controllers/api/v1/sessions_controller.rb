class Api::V1::SessionsController < ApplicationController
  respond_to :json

  # POST /api/v1/sessions
  def create
    user = User.authenticate(params[:email], params[:password])
    respond_with user, location: api_v1_users_url(user),
                       status: user.blank? ? 404 : 200
  end
end
