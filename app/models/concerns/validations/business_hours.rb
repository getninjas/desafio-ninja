# frozen_string_literal: true

module Validations
  class BusinessHours < ActiveModel::Validator
    def validate(record)
      @record = record
      validate_business_hours if record.starts_at && record.ends_at
    end

    private

    attr_accessor :record

    def validate_business_hours
      record.errors.add(:start_at, 'meeting must be in business hours') if before_nine_am? || after_six_pm? || in_weekend?
    end

    def in_weekend?
      record.starts_at.on_weekend? || record.ends_at.on_weekend?
    end

    def before_nine_am?
      record.starts_at.hour < 9
    end

    def after_six_pm?
      record.starts_at.hour > 18
    end
  end
end
