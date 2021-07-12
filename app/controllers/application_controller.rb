class ApplicationController < ActionController::API
  # Returns not found error in api standard instead an ugly exception
  rescue_from ActiveRecord::RecordNotFound do |_|
    render json: { errors: ['Record not found'] }, status: 404
  end
end
