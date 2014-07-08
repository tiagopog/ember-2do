class Api::V1::UsersController < ApplicationController
  # POST /api/v1/users
  def create
    user = User.new(user_params)
    
    if user.save 
      render json: { user_id: user.id,
                     email: user.email,
                     access_token: access_token(user) }, status: 200
    else
      render json: { message: 'Unprocessable entity',
                     errors: user.errors.full_messages }, status: 422
    end
  end

  private

  def access_token(user)
    Session.find_or_create(user).access_token
  end

  def user_params
    params.require(:user).permit(:email, :password, :name)
  end
end
