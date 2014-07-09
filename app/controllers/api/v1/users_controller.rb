class Api::V1::UsersController < ApplicationController
  # POST /api/v1/users
  def create
    user = User.new(user_params)
    
    if user.save 
      json({ user: user, access_token: user.access_token }, 200)
    else
      json({ message: http_error_msg[422],
             errors: user.errors.full_messages }, 422)
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :name)
  end
end
