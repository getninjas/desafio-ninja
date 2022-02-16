class EmployeeScheduler < ApplicationRecord
  belongs_to :scheduler
  belongs_to :employee
end