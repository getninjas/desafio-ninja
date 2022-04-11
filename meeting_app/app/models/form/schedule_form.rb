# frozen_string_literal: true

module Form
  class ScheduleForm

    include ActiveModel::Model

    attr_accessor :id, :title, :date, :start_hour, :end_hour, :room_id

    validates :title, presence: true
    validates :date, presence: true
    validates :start_hour, presence: true
    validates :end_hour, presence: true
    validates :room_id, presence: true
    validate :check_start_end

    def register
      return unless valid?

      ActiveRecord::Base.transaction do
        schedule.present? ? schedule.update(attributes) : Schedule.create(attributes)
      end
    end

    private

    def schedule
      return unless id

      Schedule.find(id)
    end

    def attributes
      { title: title, date: date, start_hour: start_hour, end_hour: end_hour, room_id: room_id }
    end

    def check_start_end
      return if start_hour.to_i < end_hour.to_i

      errors.add(:end_hour, :end_hour_invalid)
    end

  end
end
