class UpdateMeetingContract < Dry::Validation::Contract
  params do
    optional(:start_time).maybe(:time)
    optional(:end_time).maybe(:time)
    optional(:subject).maybe(:string)
    optional(:users_emails).array(:string)
  end

  rule(:start_time) do
    if value.present? && (value.saturday? || value.sunday?)
      key.failure('creating events is allowed only on weekdays.')
    end

    if value.present? && (value.strftime('%H').to_i < 9 || value.strftime('%H').to_i >= 18)
      key.failure('creating events is allowed only from 9am to 6pm on weekdays.')
    end
  end

  rule(:end_time) do
    if value.present? && (value.saturday? || value.sunday?)
      key.failure('creating events is allowed only on weekdays.')
    end

    if value.present? && (value.strftime('%H').to_i < 9 || value.strftime('%H').to_i > 18)
      key.failure('creating events is allowed only from 9am to 6pm on weekdays.')
    end
  end

  rule(:start_time, :end_time) do
    if values[:start_time].present? && values[:end_time].present? &&
        (values[:start_time] >= values[:end_time])
      key.failure('must be before end_time.')
    end
  end
end
