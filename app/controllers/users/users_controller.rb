class Users::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  skip_before_action :authenticate_request, only: %i[create]

  def index
    render json: { users: User.all}, status: :ok
  end

  def show
    if @user
        render json: { user: @user}, status: :ok
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
    if @user
      @user.update!(user_params)
      if @user.save
        render json: { user: @user}, status: :ok
      else
        render json: { errors: @user.errors}, status: :unprocessable_entity
      end
    else
      render status: :not_found
    end
  end

  def destroy
    if @user
      @user.destroy!
      render status: :ok
    else
      render status: :not_found
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit( :name, :email, :password, :password_confirmation)
  end
end
