class CreateAccessToken
  include ActiveModel::Model

  attr_accessor :user

  SECRET_KEY = Rails.application.credentials.jwt_secret_key

  def perform
    ::JWT.encode({ data: { user_id: user.id }, exp: 1.hour.from_now.to_i }, SECRET_KEY)
  end
end
