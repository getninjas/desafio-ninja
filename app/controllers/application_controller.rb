class ApplicationController < ActionController::API
  # Returns not found error in api standard instead an ugly exception
  rescue_from ActiveRecord::RecordNotFound do |_|
    render json: { errors: ['Record not found'] }, status: :not_found
  end

  def index
    render json: {
      message: 'This is an api only app, please see documentation:'\
               'https://documenter.getpostman.com/view/8419256/Tzm8FadD'
    }
  end
end
