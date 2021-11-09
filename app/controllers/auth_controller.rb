class AuthController < ApplicationController
  def token
    generate_token = GenerateToken.new(generate_token_params)

    if generate_token.perform
      render json: {
        data: {
          access_token: generate_token.access_token
        }
      }, status: 201
    else
      render json: {
        error: {
          message: generate_token.errors.first.full_message
        }
      }, status: 400
    end

  rescue ActionController::ParameterMissing => e
    render json: { error: { message: "#{e.param} must not be empty" } }, status: 400
  end

  private

  def generate_token_params
    params.require([:user_email, :password])
    params.permit(:user_email, :password)
  end
end
