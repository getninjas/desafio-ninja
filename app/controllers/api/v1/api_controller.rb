# frozen_string_literal: true

module Api
  module V1
    class ApiController < ActionController::API
      include DeviseTokenAuth::Concerns::SetUserByToken
      rescue_from ArgumentError, with: :render_argument_error
      rescue_from ActiveRecord::RecordInvalid, with: :render_invalid
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      before_action :authenticate_api_user!

      def render_argument_error(exception)
        render json: { errors: exception.message }, status: :unprocessable_entity
      end

      def render_not_found
        head :not_found
      end

      def render_invalid(exception)
        render json: { errors: exception.record.errors }, status: :unprocessable_entity
      end
    end
  end
end
