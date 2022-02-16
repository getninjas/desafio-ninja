class Employee < ApplicationRecord
  has_many :employee_schedulers
  has_many :schedulers, through: :employee_schedulers

  validates_presence_of :name, message: "can't be blank"
  validates_uniqueness_of :name, message: "must be unique"
end
