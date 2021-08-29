class Users::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[create]

  def show
    user = User.find(params[:id])
    if user
        render json: { user: user}, status: :ok
    else
      render status: :not_found
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: { user: @user}, status: :created
    else
      render json: { errors: @user.errors}, status: :unprocessable_entity
    end
  end

  def update
    user = User.find(params[:id])
    if user
      user.update!(user_params)
      if user.save
        render json: { user: user}, status: :ok
      else
        render json: { errors: user.errors}, status: :unprocessable_entity
      end
    else
      render status: :not_found
    end
  end

  def destroy
    user = User.find(params[:id])
    if user
      user.destroy!
      render status: :ok
    else
      render status: :not_found
    end
  end

  private

  def user_params
    params.permit( :name, :email, :password, :password_confirmation)
  end
end
