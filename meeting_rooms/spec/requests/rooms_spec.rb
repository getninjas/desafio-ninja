require 'rails_helper'

RSpec.describe '/rooms', type: :request do

  let(:valid_attributes) {
    { :room => { :schedulings => [] } }
  }

  let(:valid_headers) {
    {}
  }

  describe 'GET /index and GET /show' do

    4.times do |i|
      room = Room.create!
      5.times do |j|
        room.days.create!({
          week_day: j+1,
          time_from: Time.parse("09:00"),
          time_to: Time.parse("18:00"),
        })
      end
    end

    describe 'GET /index' do
      it 'renders a successful response' do
        get api_v1_rooms_url, headers: valid_headers, as: :json
        expect(response).to be_successful
        expect(response.body).to include_json([
          {
            'days' => [{
              'week_day' => 0
            }]
          },
          {
            'days' => [{
              'week_day' => 0
            }]
          },
          {
            'days' => [{
              'week_day' => 0
            }]
          },
          {
            'days' => [{
              'week_day' => 0
            }]
          },
        ])
      end
    end

    describe 'GET /show' do
      it 'renders a successful response' do
        get api_v1_room_url(Room.first), as: :json
        expect(response).to be_successful
        expect(response.body).to include_json(
          {
            'days' => [{
              'week_day' => 0
            }]
          }
        )
      end
    end
  end

end
