require 'rails_helper'

RSpec.describe 'Schedule', type: :request do
  let(:user) { create(:user) }

  before(:example) do
    sign_in user
  end
  context 'Index and show' do
    it 'expect 3 schedules' do
      room = create(:room)
      datetime = DateTime.current + 1.day

      while datetime.saturday? || datetime.sunday?
        datetime = DateTime.current + 1.day
      end

      create(
        :schedule,
        start_time: DateTime.new(datetime.year, datetime.month, datetime.day, 11, 30, 0),
        end_time: DateTime.new(datetime.year, datetime.month, datetime.day, 12, 30, 0),
        room_id: room.id
      )

      create(
        :schedule,
        start_time: DateTime.new(datetime.year, datetime.month, datetime.day, 13, 30, 0),
        end_time: DateTime.new(datetime.year, datetime.month, datetime.day, 14, 30, 0),
        room_id: room.id
      )

      create(
        :schedule,
        start_time: DateTime.new(datetime.year, datetime.month, datetime.day, 15, 30, 0),
        end_time: DateTime.new(datetime.year, datetime.month, datetime.day, 16, 30, 0),
        room_id: room.id
      )

      get "/api/rooms/#{room.id}/schedules"

      attributes = json_body[:data]
      expect(response).to have_http_status 200
      expect(attributes.count).to eq 3
    end

    it 'expect 1 schedule' do
      room = create(:room)
      datetime = DateTime.current + 1.day

      while datetime.saturday? || datetime.sunday?
        datetime = DateTime.current + 1.day
      end

      start_time = DateTime.new(datetime.year, datetime.month, datetime.day, 11, 30, 0)
      end_time = DateTime.new(datetime.year, datetime.month, datetime.day, 12, 30, 0)

      create(
        :schedule,
        start_time: start_time,
        end_time: end_time,
        room_id: room.id
      )

      get "/api/rooms/#{room.id}/schedules/#{Schedule.first.id}"

      expect(response).to have_http_status 200
    end
  end
end
