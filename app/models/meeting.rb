class Meeting < ApplicationRecord
  belongs_to :room

  validates :room_id,:starts_at, :end_at, presence: true

  validate :end_greater_start, :booking_conflict, :is_weekend?, :is_businness_hours?, :if => :fields_present?

  # Verifica se o horário inicial é maior que horário final
  def end_greater_start
    if starts_at >= end_at
      errors.add(:end_at, 'Horário de fim de reunião deve ser maior que horário inicial')
    else
      true
    end
  end

  # Verifica se há outras reuniões no mesmo horário
  def booking_conflict
    meetings_in_room = Meeting.where(room_id: room_id).where.not(id: id)
    conflicts = []
    duration = (starts_at..end_at)
    meetings_in_room.each do |meeting|
      conflicts << meeting if duration.overlaps?(meeting.starts_at..meeting.end_at)
    end

    if conflicts.present?
      message = "Sala já reservada na reunião com ID #{conflicts.pluck(:id)}"
      errors.add(:starts_at, message )
    else
      true
    end
  end

  # Verifica se a data se trata de final de semana. Retorna erro caso o parametro da Sede não permita agenda nos finais de semana
  def is_weekend?
    can_work_on_weekend = self.room.organization.work_on_weekend
    is_weekend = starts_at.on_weekend? || end_at.on_weekend?
    if is_weekend && !can_work_on_weekend
      errors.add(:starts_at, "Reuniões devem ser marcadas apenas em dias úteis")
    else
      true
    end
  end

  # Verificar se os horários não estão fora de horário comercial determinado na sede
  def is_businness_hours?
    time_starts_at = self.room.organization.business_hours_start
    time_ends_at = self.room.organization.business_hours_end

    out_of_businnes_hours = starts_at.strftime('%H:%M') < time_starts_at || end_at.strftime('%H:%M') > time_ends_at

    if out_of_businnes_hours
      key = starts_at.strftime('%H:%M') < time_starts_at ? :starts_at : :end_at
      errors.add(key, "Reuniões devem ser marcadas apenas em horários comerciais")
    else
      true
    end
  end

  # Continua validações apenas se todos os campos estiverem presentes
  def fields_present?
    errors.empty? ? true : false
  end

end
