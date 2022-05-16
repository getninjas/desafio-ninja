class MeetingContract < Dry::Validation::Contract
  params do
    required(:start_time).filled(:time)
    required(:end_time).filled(:time)
    optional(:subject).maybe(:string)
    optional(:users_emails).array(:string)
  end

  rule(:start_time) do
    key.failure('creating events is allowed only on weekdays') if value.saturday? || value.sunday?
    key.failure('creating events is allowed only until 5:59pm') if value.strftime('%H').to_i >= 18
    key.failure('creating events is allowed only before 9am') if value.strftime('%H').to_i <= 9
  end

  rule(:end_time) do
    key.failure('creating events is allowed only on weekdays') if value.saturday? || value.sunday?
    key.failure('creating events is allowed only until 5:59pm') if value.strftime('%H').to_i > 18
    key.failure('creating events is allowed only before 9am') if value.strftime('%H').to_i < 9
  end

  rule(:start_time, :start_time) do
    key.failure('must be before end_time') if values[:start_time] >= values[:start_time]
  end
end
