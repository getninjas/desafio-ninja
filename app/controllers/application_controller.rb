class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { message: e.message }, status: 404
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { message: e.message }, status: :unprocessable_entity
  end
end
