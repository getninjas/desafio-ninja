class GenerateToken
  include ActiveModel::Model

  attr_accessor :user_email, :password, :access_token

  SECRET_KEY = Rails.application.credentials.jwt_secret_key

  def perform
    user = User.find_by_email(user_email)

    if user&.password == password
      @access_token = ::JWT.encode({ data: { user_id: user.id }, exp: 1.hour.from_now.to_i }, SECRET_KEY)
    else
      errors.add(:base, :invalid, message: 'user_email or password is not valid')
      return false
    end
  end
end
