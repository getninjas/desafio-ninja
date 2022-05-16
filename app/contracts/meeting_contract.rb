class MeetingContract < Dry::Validation::Contract
  params do
    required(:start_time).filled(:time)
    required(:end_time).filled(:time)
    optional(:subject).maybe(:string)
    optional(:users_emails).array(:string)
  end

  rule(:start_time) do
    key.failure('creating events is allowed only on weekdays') if value.saturday? || value.sunday?
    key.failure(
      'creating events is allowed only from 9am to 6pm on weekdays'
    ) if value.strftime('%H').to_i < 9 && value.strftime('%H').to_i >= 18
  end

  rule(:end_time) do
    key.failure('creating events is allowed only on weekdays') if value.saturday? || value.sunday?
    key.failure(
      'creating events is allowed only from 9am to 6pm on weekdays'
    ) if value.strftime('%H').to_i < 9 && value.strftime('%H').to_i > 18
  end

  rule(:start_time, :start_time) do
    key.failure('must be before end_time') if values[:start_time] < values[:start_time]
  end
end
