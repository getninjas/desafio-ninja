require 'rails_helper'

RSpec.describe '/rooms', type: :request do

  let(:valid_attributes) {
    { :room => { :schedulings => [] } }
  }

  let(:invalid_attributes) {
    skip('Add a hash of attributes invalid for your model')
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
        get rooms_url, headers: valid_headers, as: :json
        expect(response).to be_successful
        expect(response.body).to include_json([
          {
            'days' => [{
              'week_day' => 1
            }]
          },
          {
            'days' => [{
              'week_day' => 1
            }]
          },
          {
            'days' => [{
              'week_day' => 1
            }]
          },
          {
            'days' => [{
              'week_day' => 1
            }]
          },
        ])
      end
    end

    describe 'GET /show' do
      it 'renders a successful response' do
        get room_url(Room.first), as: :json
        expect(response).to be_successful
        expect(response.body).to include_json(
          {
            'days' => [{
              'week_day' => 1
            }]
          }
        )
      end
    end
  end
=begin
  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Room' do
        expect {
          post rooms_url,
               params: { room: valid_attributes }, headers: valid_headers, as: :json
        }.to change(Room, :count).by(1)
      end

      it 'renders a JSON response with the new room' do
        post rooms_url,
             params: { room: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

  end

  describe 'DELETE /destroy' do
    it 'destroys the requested room' do
      room = Room.create!
      expect {
        delete room_url(room), headers: valid_headers, as: :json
      }.to change(Room, :count).by(-1)
    end
  end
=end
end
