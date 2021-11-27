require 'rails_helper'

RSpec.describe "Meetings", type: :request do
  describe "GET /index" do
    let(:room) { create(:room) }
    let!(:meeting_one) do 
      create(:meeting, starts_at: DateTime.parse("2021-11-25 10:00:00"), ends_at: DateTime.parse("2021-11-25 11:00:00"), room: room)
    end
    let!(:meeting_two) do
      create(:meeting, starts_at: DateTime.parse("2021-11-25 13:00:00"), ends_at: DateTime.parse("2021-11-25 14:00:00"), room: room)
    end
    let!(:meeting_three) { create(:meeting) }

    context 'show all meetings' do
      it do 
        get '/meetings'
        expect(response).to have_http_status(:ok)
        expect(parsed_response.size).to eq(3)        
      end
    end

    context 'show all meetings from a specific room' do
      it do
        get '/meetings', params: { room_id: room.id }  

        expect(response).to have_http_status(:ok)
        expect(parsed_response.size).to eq(2)
      end
    end
  end


  describe 'GET /show' do
    let(:meeting) { create(:meeting) }

    context 'show a specific meeting' do
      it 'fails when requested a invalid id' do
        get '/meetings/404'
        expect(response).to have_http_status(404)
      end

      it 'success when meeting is found' do
        get "/meetings/#{meeting.id}"
        expect(response).to have_http_status(:ok)
      end
    end
  end


  describe 'POST /meetings' do
    let(:room) { create(:room) }
    let(:invalid_params) do
      {
        "title" => "Outra reunião importante",
        "starts_at" => "2021-11-25 08:00:00",
        "ends_at" => "2021-11-25 10:00:00",
        "room_id" => room.id
      }
    end

    let(:valid_params) do
      {
        "title" => "Outra reunião importante",
        "starts_at" => "2021-11-25 09:00:00",
        "ends_at" => "2021-11-25 10:00:00",
        "room_id" => room.id
      }
    end

    context 'meetings creation' do
      it 'fails when invalids params are used' do
        post '/meetings', params: invalid_params
        expect(response).to have_http_status(422)
      end

      it 'success when valid params are used' do
        post '/meetings', params: valid_params
        expect(response).to have_http_status(201)
      end
    end
  end


  describe 'PUT /meetings' do
    let(:room) { create(:room) }
    let(:meeting) { create(:meeting) }
    let(:invalid_params) do
      {
        "title" => "Outra reunião importante",
        "starts_at" => "2021-11-25 08:00:00",
        "ends_at" => "2021-11-25 10:00:00",
        "room_id" => room.id
      }
    end

    let(:valid_params) do
      {
        "title" => "Outra reunião importante",
        "starts_at" => "2021-11-25 09:00:00",
        "ends_at" => "2021-11-25 10:00:00",
        "room_id" => room.id
      }
    end

    context 'meetings creation' do
      it 'fails when invalids params are used' do
        put "/meetings/#{meeting.id}", params: invalid_params
        expect(response).to have_http_status(422)
      end

      it 'success when valid params are used' do
        put "/meetings/#{meeting.id}", params: valid_params
        expect(response).to have_http_status(200)
      end
    end
  end
end
