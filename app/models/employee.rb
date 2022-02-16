class Employee < ApplicationRecord
  has_and_belongs_to_many :schedulers

  validates_presence_of :name, message: "can't be blank"
  validates_uniqueness_of :name, message: "must be unique"
end
