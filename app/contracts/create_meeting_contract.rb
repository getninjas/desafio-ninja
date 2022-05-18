class CreateMeetingContract < Dry::Validation::Contract
  params do
    required(:start_time).filled(:time)
    required(:end_time).filled(:time)
    optional(:subject).maybe(:string)
    optional(:users_emails).array(:string)
  end

  rule(:start_time) do
    key.failure('creating events is allowed only on weekdays.') if value.saturday? || value.sunday?
    if value.strftime('%H').to_i < 9 || value.strftime('%H').to_i >= 18
      key.failure('creating events is allowed only from 9am to 6pm on weekdays.')
    end
  end

  rule(:end_time) do
    key.failure('creating events is allowed only on weekdays.') if value.saturday? || value.sunday?
    if value.strftime('%H').to_i < 9 || value.strftime('%H').to_i > 18
      key.failure('creating events is allowed only from 9am to 6pm on weekdays.')
    end
  end

  rule(:start_time, :end_time) do
    key.failure('must be before end_time.') if values[:start_time] >= values[:end_time]
  end
end
