class Meeting < ApplicationRecord
  belongs_to :room

  has_many :invited_meetings
  has_many :users, :through => :invited_meetings

  belongs_to :owner, :class_name => "User", :foreign_key => :user_id
end
