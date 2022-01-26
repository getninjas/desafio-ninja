class Agenda < ApplicationRecord
  belongs_to :sala
  has_many   :agendamentos
end
