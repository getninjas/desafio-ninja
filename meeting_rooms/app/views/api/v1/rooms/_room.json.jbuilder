json.extract! room, :id, :schedulings, :created_at, :updated_at, :days
json.url api_v1_room_url(room, format: :json)
