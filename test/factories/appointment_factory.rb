FactoryBot.define do
  factory :appointment do
    responsible_name { 'responsible' }
    start_time { default_start_time }
    end_time { default_start_time + 1.hour }
    room { build(:room) }
  end
end

private
def default_start_time
  Time.current.since(1.day).beginning_of_day + 10.hour
end