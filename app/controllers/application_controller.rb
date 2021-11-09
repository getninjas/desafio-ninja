class ApplicationController < ActionController::API
  private

  def authenticate_user
    access_token = request.headers['Authorization']&.remove(/^Bearer /)
    @current_user = DecodeAccessToken.new.perform(access_token)

  rescue JWT::ExpiredSignature, ActiveRecord::RecordNotFound, JWT::DecodeError
    return render json: { error: { message: 'Not Authorized' } }, status: 401
  end
end
