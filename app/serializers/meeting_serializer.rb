class MeetingSerializer < ActiveModel::Serializer
  attributes :id, :title, :start_date, :end_date

  def start_date
    object.starts_at.try(:strftime, '%d/%m/%Y - %H:%M')
  end

  def end_date
    object.ends_at.try(:strftime, '%d/%m/%Y - %H:%M')
  end
end
