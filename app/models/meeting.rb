class Meeting < ApplicationRecord
  belongs_to :room

  has_many :invited_meetings, dependent: :destroy
  has_many :users, through: :invited_meetings, dependent: :destroy

  belongs_to :owner, class_name: 'User', foreign_key: :user_id
end
