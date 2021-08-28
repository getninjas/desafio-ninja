class Users::UsersController < ApplicationController
  before_action :authenticate_request, except: %i[create]

  def create
    @user = User.new(user_params)

    if @user.save
      render json: { user: @user}, status: :created
    else
      render json: { errors: @user.errors}, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
