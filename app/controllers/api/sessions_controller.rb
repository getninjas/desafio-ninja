# frozen_string_literal: true

module Api
  class SessionsController < Devise::SessionsController
    deserializable_resource :user, only: [:create]

    before_action :sign_in_params, only: [:create]

    def create
      successful_callback = lambda do |caller|
        sign_in caller, store: false
        render jsonapi: caller, status: :ok
      end

      error_callback = lambda do |caller|
        render jsonapi_errors: caller.errors, status: :unauthorized
      end

      UserLogin.perform(
        sign_in_params,
        {
          success: successful_callback,
          error: error_callback
        }
      )
    end

    private

    def respond_to_on_destroy
      head :no_content
    end

    def sign_in_params
      params.require(:user).permit(:login, :password)
    end
  end
end