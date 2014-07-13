class Api::V1::UsersController < ApplicationController
  respond_to :json

  # POST /api/v1/users
  def create
    user = User.new(user_params)
    
    if user.save 
      respond_with user, location: api_v1_users_url(user), status: 200
    else
      render json: { errors: user.errors.full_messages }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :name)
  end
end
