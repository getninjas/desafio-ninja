require 'rails_helper'

RSpec.describe 'Create Schedule', type: :request do
  let(:user) { create(:user) }

  before(:example) do
    sign_in user
  end
  context 'Doing a valid schedule' do
    it 'Creating schedule' do
      room = create(:room)
      schedule = attributes_for(:schedule, room: room, user: user)

      post "/api/rooms/#{room.id}/schedules", params: { schedule: schedule }

      expect(response).to have_http_status 201
      expect(response).not_to have_http_status 422
      expect(response).not_to have_http_status 401
    end
  end

  context 'Doing a invalid schedule' do
    it 'trying to create a schedule record with invalid start time' do
      room = create(:room)
      schedule = attributes_for(:schedule, start_time: DateTime.current + 2.days)
      post "/api/rooms/#{room.id}/schedules", params: { schedule: schedule }

      expect(response).to have_http_status 422
    end

    it 'trying to create a schedule record with invalid room' do
      schedule = attributes_for(:schedule)
      post "/api/rooms/#{SecureRandom.uuid}/schedules", params: { schedule: schedule }

      expect(response).to have_http_status 422
    end
  end
end
