# frozen_string_literal: true

class User < ActiveRecord::Base
  extend Devise::Models
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :invited_meetings, dependent: :destroy
  has_many :meetings, through: :invited_meetings, dependent: :destroy

  has_many :created_meetings, class_name: 'Meeting', dependent: :destroy
end
