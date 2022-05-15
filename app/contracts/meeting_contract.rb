class MeetingContract < Dry::Validation::Contract
  params do
    required(:start_time).filled(:date)
    required(:end_time).filled(:date)
    required(:users_emails).array(:string)
  end
end
