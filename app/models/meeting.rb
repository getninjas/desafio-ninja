class Meeting < ApplicationRecord
  belongs_to :room

  validates :room_id,:starts_at, :end_at, presence: true

  validate :end_greater_start, :booking_conflict, :is_weekend?, :is_businness_hours?


  # Manipulação de formatos de Data em substituição ao I18n
  DATE_FORMAT = {default: "%d/%m/%Y %H:%M",
                 american: "%m/%d/%Y %H:%M"
                }

  def end_greater_start
    if starts_at >= end_at
      errors.add(:end_at, 'Horário de fim de reunião deve ser maior que horário inicial')
    else
      true
    end
  end

  def booking_conflict
    meetings_in_room = Meeting.where(room_id: room_id)
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

  def is_weekend?
    can_work_on_weekend = self.room.organization.work_on_weekend
    is_weekend = starts_at.on_weekend? || end_at.on_weekend?
    if is_weekend && !can_work_on_weekend
      errors.add(:starts_at, "Reuniões devem ser marcadas apenas em dias úteis")
    else
      true
    end
  end

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

  def limit_reached?(start_date, end_date)
    date_format = DATE_FORMAT[:default]

    start_date = DateTime.strptime(start_date, date_format) rescue nil
    end_date = DateTime.strptime(end_date, date_format) rescue nil

    invalid_date = start_date.nil? || end_date.nil?

    if invalid_date
      key = start_date.nil? ? :starts_at : :end_at
      errors.add(key, "Data informada deve estar em um formato válido")
      true
    else
      false
    end
  end

end
