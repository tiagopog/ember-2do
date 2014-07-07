class Api::V1::SessionsController < ApplicationController
  # POST /api/v1/sessions
  def create
    user = User.authenticate(params[:email], params[:password])
    
    if user.blank?
      render json: { message: 'Unknown user' }, status: 401
    else
      render json: { message: 'Authentication has succeeded',
                     access_token: Session.find_or_create(user).access_token }, 
                     status: 200
    end
  end
end
