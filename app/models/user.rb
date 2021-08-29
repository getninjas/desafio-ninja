class User < ApplicationRecord
  has_secure_password

  has_many :schedule_rooms, dependent: :destroy
end
