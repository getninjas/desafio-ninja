require 'rails_helper'

RSpec.describe 'Schedule', type: :request do
  let(:user) { create(:user) }

  before(:example) do
    sign_in user
  end
  context 'Update schedule' do
    it 'Updating start_time with success' do
      room = create(:room)
      datetime = DateTime.current
      start_time = DateTime.new(datetime.year, datetime.month, datetime.day, 11, 30, 0)
      end_time = DateTime.new(datetime.year, datetime.month, datetime.day, 12, 30, 0)

      schedule = create(
        :schedule,
        start_time: start_time,
        end_time: end_time,
        room_id: room.id,
        user_id: user.id
      )
      old_start_time = schedule.start_time

      patch "/api/rooms/#{room.id}/schedules/#{schedule.id}", params: { schedule: { start_time: start_time + 10.minutes } }

      expect(response).to have_http_status 200
      attributes = json_body[:data][:attributes]
      expect(attributes[:start_time]).not_to eq old_start_time
    end

    it 'Updating end_time with success' do
      room = create(:room)
      datetime = DateTime.current
      start_time = DateTime.new(datetime.year, datetime.month, datetime.day, 11, 30, 0)
      end_time = DateTime.new(datetime.year, datetime.month, datetime.day, 12, 30, 0)

      schedule = create(
        :schedule,
        start_time: start_time,
        end_time: end_time,
        room_id: room.id,
        user_id: user.id
      )
      old_end_time = schedule.end_time

      patch "/api/rooms/#{room.id}/schedules/#{schedule.id}", params: { schedule: { end_time: end_time + 10.minutes } }

      expect(response).to have_http_status 200
      attributes = json_body[:data][:attributes]
      expect(attributes[:end_time]).not_to eq old_end_time
    end

    it 'Updating start_time without success' do
      room = create(:room)
      datetime = DateTime.current
      start_time = DateTime.new(datetime.year, datetime.month, datetime.day, 11, 30, 0)
      end_time = DateTime.new(datetime.year, datetime.month, datetime.day, 12, 30, 0)

      schedule = create(
        :schedule,
        start_time: start_time,
        end_time: end_time,
        room_id: room.id,
        user_id: user.id
      )

      patch "/api/rooms/#{room.id}/schedules/#{schedule.id}", params: { schedule: { start_time: end_time + 10.minutes } }

      expect(response).to have_http_status 422
    end
  end
end
