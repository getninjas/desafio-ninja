class UserLogin
  include ActiveModel::Model
  attr_accessor :login, :password
  attr_reader :callbacks, :user

  validates :user, presence: {message: :not_found}
  validates :login, :password, presence: {message: :blank}
  validate :valid_password?, :locked?, if: :user

  def self.perform(params, callbacks)
    new(params, callbacks).sign_in
  end

  def initialize(params, callbacks)
    super params
    @callbacks = callbacks
  end

  def sign_in
    load_user
    if valid?
      callbacks[:success]&.call(user)
    else
      callbacks[:error]&.call(self)
    end
  end

  private

  def valid_password?
    return if user.valid_for_authentication? { user.valid_password?(password) }

    errors.add(:base, :unauthorized)
  end

  def locked?
    return unless user.access_locked?

    errors.add(:base, I18n.t('devise.failure.locked'))
  end

  def load_user
    @user = User.find_for_database_authentication(email: @login)
  end
end
