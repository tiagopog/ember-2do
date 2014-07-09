class Api::V1::SessionsController < ApplicationController
  # POST /api/v1/sessions
  def create
    user = User.authenticate(params[:email], params[:password])
    
    if user.blank?
      json({ message: http_error_msg[404] }, 404)
    else
      json({ message: 'Authentication has succeeded',
             access_token: user.access_token }, 200)
    end
  end
end
