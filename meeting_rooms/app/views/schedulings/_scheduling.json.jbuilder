json.extract! scheduling, :id, :created_at, :updated_at, :date, :time, :duration
json.url room_schedulings_url(scheduling, format: :json)
