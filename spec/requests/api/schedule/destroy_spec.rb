require 'rails_helper'

RSpec.describe 'Schedule', type: :request do
  let(:user) { create(:user) }

  before(:example) do
    sign_in user
  end
  context 'Destroy schedule' do
    it 'destroy with success' do
      room = create(:room)
      datetime = DateTime.current + 1.day
      while datetime.saturday? || datetime.sunday?
        datetime = DateTime.current + 1.day
      end

      start_time = DateTime.new(datetime.year, datetime.month, datetime.day, 11, 30, 0)
      end_time = DateTime.new(datetime.year, datetime.month, datetime.day, 12, 30, 0)

      schedule = create(
        :schedule,
        start_time: start_time,
        end_time: end_time,
        room_id: room.id,
        user_id: user.id
      )

      delete "/api/rooms/#{room.id}/schedules/#{schedule.id}"

      expect(response).to have_http_status 200
    end

    it 'destroy without success' do
      room = create(:room)
      datetime = DateTime.current + 1.day

      while datetime.saturday? || datetime.sunday?
        datetime = DateTime.current + 1.day
      end

      start_time = DateTime.new(datetime.year, datetime.month, datetime.day, 11, 30, 0)
      end_time = DateTime.new(datetime.year, datetime.month, datetime.day, 12, 30, 0)

      schedule = create(
        :schedule,
        start_time: start_time,
        end_time: end_time,
        room_id: room.id
      )

      delete "/api/rooms/#{room.id}/schedules/#{schedule.id}"

      expect(response).to have_http_status 422
    end
  end
end
