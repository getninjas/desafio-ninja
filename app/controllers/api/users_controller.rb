module Api
  class UsersController < ApplicationController

    deserializable_resource :user, only: %i[create update]

    before_action :authenticate_api_user!, only: %i[index]

    def index
      CRUDManagement::Index.perform(
        paginate_params.merge(ransack_params: ransack_options),
        index_with_pagination_callback,
        User
      )
    end

    def show
      CRUDManagement::Show.perform(
        find_params,
        default_show_callbacks,
        User
      )
    end

    def create
      CRUDManagement::Create.perform(
        user_params,
        default_create_callbacks,
        User
      )
    end

    def update
      CRUDManagement::Update.perform(
        find_params,
        update_user_params,
        default_update_callbacks,
        User.where(id: current_api_user.id)
      )
    end

    private

    def user_params
      params.require(:user).permit(:id, :name, :email, :password, :password_confirmation)
    end

    def update_user_params
      params.require(:user).permit(:id, :name)
    end

    def find_params
      { id: params.require(:id)}
    end
  end
end