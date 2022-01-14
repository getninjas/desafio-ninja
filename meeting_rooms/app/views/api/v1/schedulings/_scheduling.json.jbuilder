json.extract! scheduling, :id, :created_at, :updated_at, :date, :time, :duration
json.url api_v1_room_schedulings_url(scheduling, format: :json)
