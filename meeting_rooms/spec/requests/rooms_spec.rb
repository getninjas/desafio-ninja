require 'rails_helper'

RSpec.describe '/rooms', type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Room. As you add validations to Room, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip('Add a hash of attributes valid for your model')
  }

  let(:invalid_attributes) {
    skip('Add a hash of attributes invalid for your model')
  }

  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # RoomsController, or in your router and rack
  # middleware. Be sure to keep this updated too.
  let(:valid_headers) {
    {}
  }

  describe 'GET /index' do
    it 'renders a successful response' do
      Room.create! valid_attributes
      get rooms_url, headers: valid_headers, as: :json
      expect(response).to be_successful
      expect(response.body).to include_json(

      )
    end
  end

=begin
  describe 'GET /show' do
    it 'renders a successful response' do
      room = Room.create! valid_attributes
      get room_url(room), as: :json
      expect(response).to be_successful
    end
  end

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

    context 'with invalid parameters' do
      it 'does not create a new Room' do
        expect {
          post rooms_url,
               params: { room: invalid_attributes }, as: :json
        }.to change(Room, :count).by(0)
      end

      it 'renders a JSON response with errors for the new room' do
        post rooms_url,
             params: { room: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) {
        skip('Add a hash of attributes valid for your model')
      }

      it 'updates the requested room' do
        room = Room.create! valid_attributes
        patch room_url(room),
              params: { room: new_attributes }, headers: valid_headers, as: :json
        room.reload
        skip('Add assertions for updated state')
      end

      it 'renders a JSON response with the room' do
        room = Room.create! valid_attributes
        patch room_url(room),
              params: { room: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the room' do
        room = Room.create! valid_attributes
        patch room_url(room),
              params: { room: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested room' do
      room = Room.create! valid_attributes
      expect {
        delete room_url(room), headers: valid_headers, as: :json
      }.to change(Room, :count).by(-1)
    end
  end
=end
end
