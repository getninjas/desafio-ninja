require 'rails_helper'

RSpec.describe 'Room', type: :request do
  let(:user) { create(:user) }

  before(:example) do
    sign_in user
  end
  context 'Index and show' do
    it 'expect 10 rooms' do
      create_list(:room, 10)

      get '/api/rooms'

      attributes = json_body[:data]
      expect(response).to have_http_status 200
      expect(attributes.count).to eq 10
    end

    it 'expect 1 room' do
      room = create(:room)

      get "/api/rooms/#{room.id}"

      attributes = json_body[:data][:attributes]
      expect(response).to have_http_status 200
      expect(room.id).to eq (json_body[:data][:id])
      expect(room.number).to eq (attributes[:number])
      expect(room.description).to eq (attributes[:description])
    end

    it 'expect 0 room' do

      get "/api/rooms"

      attributes = json_body[:data].count
      expect(response).to have_http_status 200
      expect(attributes).to eq 0
    end

    it 'expect error' do

      get "/api/rooms/#{SecureRandom.uuid}"

      expect(response).to have_http_status 422
    end
  end

end
