require 'rails_helper'

RSpec.describe "Schedules", type: :request do
  let!(:rooms) { create_list(:room, 2) }
  let!(:user) { create(:user) }

  describe "GET /schedules" do
    let(:perform) { get '/schedules' }

    context 'when there is not schedule' do
      let(:expected) { { data: { rooms: [] } }.to_json }

      it "returns an empty array" do
        perform

        expect(response.body).to eq(expected)
      end
    end

    context 'when there are schedules for only one room' do
      let!(:schedule) { create(:schedule, user: user, room: rooms.first) }
      let(:expected) do
        {
          data: {
            rooms: [
              {
                rooms.first.name => [
                  {
                    start_time: schedule.start_time.strftime('%Y-%m-%d %H:%M:%S'),
                    end_time: schedule.end_time.strftime('%Y-%m-%d %H:%M:%S'),
                  }
                ]
              }
            ]
          }
        }.to_json
      end

      it 'returns the schedules for only one room' do
        perform

        expect(response.body).to eq(expected)
      end
    end

    context 'when there are schedules for more than one room' do
    end
  end
end
