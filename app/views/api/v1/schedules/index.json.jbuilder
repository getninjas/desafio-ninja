json.schedules do
  json.array! @schedules do |schedule|
    json.partial! schedule
  end
end

