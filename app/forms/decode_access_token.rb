class DecodeAccessToken
  include ActiveModel::Model

  SECRET_KEY = Rails.application.credentials.jwt_secret_key

  def perform(access_token)
    decoded = ::JWT.decode(access_token, SECRET_KEY).first['data']
    decoded = HashWithIndifferentAccess.new decoded

    User.find(decoded[:user_id])
  end
end
