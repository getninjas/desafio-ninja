class User < ApplicationRecord

  devise  :database_authenticatable,
          :lockable,
          :recoverable,
          :trackable,
          :validatable,
          :jwt_authenticatable,
          jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null,
          authentication_keys: [:login]

  validates :name, presence: true, allow_nil: false
  validates :password_confirmation, presence: true, on: :create

  has_many :schedules
end
