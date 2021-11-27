# frozen_string_literal: true

class RoomSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_date, :updated_date
  has_many :meetings, serializer: MeetingSerializer

  def created_date
    object.created_at.try(:strftime, '%d/%m/%Y')
  end

  def updated_date
    object.updated_at.try(:strftime, '%d/%m/%Y')
  end
end
