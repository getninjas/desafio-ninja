require 'rails_helper'

RSpec.describe "/schedulings", type: :request do

  let(:valid_attributes) {
    { :date => "2022-01-01", :time => "2022-01-01T06:00:00.000-03:00", :duration => 60 }
  }

  let(:invalid_attributes) {
    { :date => nil, :time => nil }
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

    describe "GET /index" do
      it "renders a successful response" do
        room = Room.first
        Scheduling.create! valid_attributes.merge({:room_id => Room.first})
        get room_schedulings_url(room_id: room.id), headers: valid_headers, as: :json
        expect(response).to be_successful
        expect(response.body).to include_json(
          [{
            'date' => valid_attributes[:date],
            'time' => Time.parse(valid_attributes[:time]).as_json
          }]
        )
      end
    end

    describe "GET /show" do
      it "renders a successful response" do
        room = Room.first
        scheduling = Scheduling.create! valid_attributes.merge({:room_id => Room.first})
        get room_schedulings_url(scheduling), as: :json
        expect(response).to be_successful
      end
    end
  end

=begin
  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Scheduling" do
        expect {
          post schedulings_url,
               params: { scheduling: valid_attributes }, headers: valid_headers, as: :json
        }.to change(Scheduling, :count).by(1)
      end

      it "renders a JSON response with the new scheduling" do
        post schedulings_url,
             params: { scheduling: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Scheduling" do
        expect {
          post schedulings_url,
               params: { scheduling: invalid_attributes }, as: :json
        }.to change(Scheduling, :count).by(0)
      end

      it "renders a JSON response with errors for the new scheduling" do
        post schedulings_url,
             params: { scheduling: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json")
      end
    end
  end

=begin
  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested scheduling" do
        scheduling = Scheduling.create! valid_attributes
        patch scheduling_url(scheduling),
              params: { scheduling: new_attributes }, headers: valid_headers, as: :json
        scheduling.reload
        skip("Add assertions for updated state")
      end

      it "renders a JSON response with the scheduling" do
        scheduling = Scheduling.create! valid_attributes
        patch scheduling_url(scheduling),
              params: { scheduling: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the scheduling" do
        scheduling = Scheduling.create! valid_attributes
        patch scheduling_url(scheduling),
              params: { scheduling: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json")
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested scheduling" do
      scheduling = Scheduling.create! valid_attributes
      expect {
        delete scheduling_url(scheduling), headers: valid_headers, as: :json
      }.to change(Scheduling, :count).by(-1)
    end
  end
=end
end
