require 'rails_helper'

RSpec.describe "/schedulings", type: :request do

  let(:invalid_attributes) {
    { :date => "01-05", :time => "20:00.000-00:00", :duration => 60 }
  }

  let(:valid_headers) {
    {}
  }

  describe 'GET /index AND /show > ' do

    let(:valid_attributes) {
      { :date => "2022-01-03", :time => "2022-01-03T09:00:00.000-00:00", :duration => 60 }
    }

    Room.all.destroy

    4.times do |i|
      room = Room.create!
      5.times do |j|
        room.days.create!({
          week_day: j,
          time_from: Time.parse("09:00"),
          time_to: Time.parse("18:00"),
        })
      end
    end

    describe "GET /index" do
      it "renders a successful response" do
        room = Room.first
        Scheduling.create! valid_attributes.merge({:room_id => room.id})
        get api_v1_room_schedulings_path(room_id: room.id), headers: valid_headers, as: :json
        expect(response).to be_successful
        expect(response.body).to include_json(
          [{
            'date' => valid_attributes[:date],
            'time' => Time.parse(valid_attributes[:time]).as_json,
            'duration' => valid_attributes[:duration]
          }]
        )
      end
    end

    describe "GET /show" do
      it "renders a successful response" do
        room = Room.first
        scheduling = Scheduling.create! valid_attributes.merge({:room_id => room.id}).merge({:time => (Time.parse(valid_attributes[:time]) + 90.minutes)})
        get api_v1_room_scheduling_path(room_id: room.id, id: scheduling.id), as: :json
        expect(response).to be_successful
        expect(response.body).to include_json(
          {
            'date' => valid_attributes[:date],
            'time' => (Time.parse(valid_attributes[:time]) + 90.minutes).as_json,
            'duration' => 60
          }
        )
      end
    end

  end

  describe "POST /create" do

    room = Room.first

    context "with valid parameters 1" do

      let(:valid_attributes) {
        { :date => "2022-01-04", :time => "2022-01-04T09:00:00.000-00:00", :duration => 60 }
      }

      it "creates a new Scheduling" do

        expect {
          post api_v1_room_schedulings_url(room_id: room.id),
               params: valid_attributes.merge({:room_id => room.id}), headers: valid_headers, as: :json
        }.to change(Scheduling, :count).by(1)
      end
    end

    context "with valid parameters 2" do

      let(:valid_attributes) {
        { :date => "2022-01-05", :time => "2022-01-05T09:00:00.000-00:00", :duration => 60 }
      }

      it "renders a JSON response with the new scheduling" do

        post api_v1_room_schedulings_url(room_id: room.id),
             params: valid_attributes.merge({:room_id => Room.first}), headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Scheduling" do
        expect {
          post api_v1_room_schedulings_url(room_id: room.id),
               params: invalid_attributes.merge({:room_id => room.id}), as: :json
        }.to change(Scheduling, :count).by(0)
      end

      it "renders a JSON response with errors for the new scheduling" do
        post api_v1_room_schedulings_url(room_id: room.id),
             params: invalid_attributes.merge({:room_id => room.id}), headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end

    context "with not availability - Non-working day" do

      let(:valid_attributes) {
        { :date => "2022-01-01", :time => "2022-01-01T17:00:00.000-00:00", :duration => 60 }
      }

      it "renders a JSON response with errors for the scheduling" do
        post api_v1_room_schedulings_url(room_id: room.id),
             params: valid_attributes.merge({:room_id => Room.first}), headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response.body).to include_json(
          {
            'availability' => ['Non-working day']
          }
        )
      end
    end

    context "with not availability - Time coincides with another appointment" do

      let(:valid_attributes) {
        { :date => "2022-01-19", :time => "2022-01-19T17:00:00.000-00:00", :duration => 60 }
      }

      it "renders a JSON response with errors for the scheduling" do
        Scheduling.create! valid_attributes.merge({:room_id => room.id})
        post api_v1_room_schedulings_url(room_id: room.id),
             params: valid_attributes.merge({:room_id => Room.first}), headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response.body).to include_json(
          {
            'availability' => ['Time coincides with another appointment']
          }
        )
      end
    end

    context "with not availability - Out of business hours" do

      let(:valid_attributes) {
        { :date => "2022-01-20", :time => "2022-01-20T18:00:00.000-00:00", :duration => 60 }
      }

      it "renders a JSON response with errors for the scheduling" do
        post api_v1_room_schedulings_url(room_id: room.id),
             params: valid_attributes.merge({:room_id => Room.first}), headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response.body).to include_json(
          {
            'availability' => ['Out of business hours']
          }
        )
      end
    end

  end

  describe "PATCH /update" do

    room = Room.first

    context "with valid parameters 1" do

      let(:valid_attributes) {
        { :date => "2022-01-10", :time => "2022-01-10T09:00:00.000-00:00", :duration => 60 }
      }

      let(:new_attributes) {
        { :date => "2022-01-10", :time => "2022-01-10T12:00:00.000-00:00", :duration => 60 }
      }

      it "updates the requested scheduling" do
        scheduling = Scheduling.create! valid_attributes.merge({:room_id => room.id})
        patch api_v1_room_scheduling_url(room_id: room.id, id: scheduling.id),
              params: new_attributes, headers: valid_headers, as: :json
        scheduling.reload
        # skip("Add assertions for updated state")
      end
    end

    context "with valid parameters 2" do
      let(:valid_attributes) {
        { :date => "2022-01-11", :time => "2022-01-11T09:00:00.000-00:00", :duration => 60 }
      }

      let(:new_attributes) {
        { :date => "2022-01-11", :time => "2022-01-11T17:00:00.000-00:00", :duration => 60 }
      }

      it "renders a JSON response with the scheduling" do
        scheduling = Scheduling.create! valid_attributes.merge({:room_id => room.id})
        patch api_v1_room_scheduling_url(room_id: room.id, id: scheduling.id),
              params: new_attributes, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json; charset=utf-8"))
      end
    end

    context "with invalid parameters" do

      let(:valid_attributes) {
        { :date => "2022-01-12", :time => "2022-01-12T09:00:00.000-00:00", :duration => 60 }
      }

      it "renders a JSON response with errors for the scheduling" do
        scheduling = Scheduling.create! valid_attributes.merge({:room_id => room.id})
        patch api_v1_room_scheduling_url(room_id: room.id, id: scheduling.id),
              params: invalid_attributes, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end
  end

  describe "DELETE /destroy" do

    let(:valid_attributes) {
      { :date => "2022-01-06", :time => "2022-01-06T09:00:00.000-00:00", :duration => 60 }
    }

    it "destroys the requested scheduling" do

      room = Room.first

      scheduling = Scheduling.create! valid_attributes.merge({:room_id => room.id})
      expect {
        delete api_v1_room_scheduling_url(room_id: room.id, id: scheduling.id), headers: valid_headers, as: :json
      }.to change(Scheduling, :count).by(-1)
    end
  end

end
