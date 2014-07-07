class Api::V1::UsersController < ApplicationController
  before_action :authenticate

  # POST /api/v1/users.json
  def create
    @user = User.new(params[:user])
    
    if @user.save 
      render json: @user, status: 200
    else
      render json: { message: 'Bad request' }, status: 400
    end
  end
end
