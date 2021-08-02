require 'rails_helper'

RSpec.describe "Api::V1::Schedules", type: :request do
  let(:room) { create(:room) }

  context "GET rooms/:room_id/schedules" do
    let!(:schedule) { create(:schedule, room: room) }
    let(:url) { "/api/v1/rooms/#{schedule.room_id}/schedules" }

    it "should return all schedules from room" do
      get url
      expect(response).to have_http_status(:ok)
      expect(body_json['schedules'].count).to eq(room.schedules.count)
      expect(body_json['schedules']).to eq([build_schedule_json(room.schedules.first)])
    end

    it "should return not found status when room does not exists" do
      url = "/api/v1/rooms/#{Faker::Crypto.md5}/schedules"
      get url
      expect(response).to have_http_status(:not_found)
      expect(response.message).to eq("Not Found")
    end
  end

  context "GET rooms/:room_id/schedules/:id" do
    let(:schedule) { create(:schedule, room: room) }
    let(:url) { "/api/v1/rooms/#{schedule.room_id}/schedules/#{schedule.id}" }

    it "should return schedule" do
      get url
      expect(response).to have_http_status(:ok)
      expect(body_json['schedule']).to eq(build_schedule_json(Schedule.find(schedule.id)))
    end

    it "should return not found status when schedule does not exists" do
      url = "/api/v1/rooms/#{schedule.room_id}/schedules/#{Faker::Crypto.md5}"
      get url
      expect(response).to have_http_status(:not_found)
      expect(response.message).to eq("Not Found")
    end
  end

  context "POST rooms/:room_id/schedules" do
    let(:room) { create(:room) }
    let(:url) { "/api/v1/rooms/#{room.id}/schedules" }

    it "should create schedule in commercial time" do
      schedule_params = { schedule: attributes_for(:schedule, room: room) }

      post url, params: schedule_params
      expect(response).to have_http_status(:ok)
      expect(body_json['schedule']).to eq(build_schedule_json(Schedule.last))
    end

    it "should not create schedule out of business time (on weekday)" do
      out_business_time_schedule_params = {
        schedule: attributes_for(:schedule,
          room: room,
          start_at: DateTime.now.beginning_of_day + 8.hour,
          end_at: DateTime.now.beginning_of_day + 9.hour
        )
      }

      post url, params: out_business_time_schedule_params
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "should not create schedule out of business time (on weekend)" do
      out_business_time_schedule_params = {
        schedule: attributes_for(:schedule,
          room: room,
          start_at: Date.today.beginning_of_week(:saturday) + 9.hour,
          end_at: Date.today.beginning_of_week(:saturday) + 10.hour
        )
      }

      post url, params: out_business_time_schedule_params
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "should not create schedule in scheduled time" do
      schedule = create(:schedule, room: room)

      scheduled_schedule_params = {
        schedule: attributes_for(:schedule,
          room: room,
          start_at: schedule.start_at + 0.5.hour,
          end_at: schedule.end_at
        )
      }

      post url, params: scheduled_schedule_params
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "should not create schedule with end less_or_equal to start" do
      end_less_schedule_params = {
        schedule: attributes_for(:schedule,
          room: room,
          start_at: DateTime.now.beginning_of_day + 10.hour,
          end_at: DateTime.now.beginning_of_day + 9.hour
        )
      }

      post url, params: end_less_schedule_params
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context "PUT rooms/:room_id/schedules/:id" do
    let(:schedule) { create(:schedule, room: room) }
    let(:url) { "/api/v1/rooms/#{schedule.room_id}/schedules/#{schedule.id}" }

    it "should update schedule" do
      schedule_params = {
        schedule: {
          start_at: DateTime.now.beginning_of_day + 13.hour,
          end_at: DateTime.now.beginning_of_day + 14.hour
        }
      }

      put url, params: schedule_params
      expect(response).to have_http_status(:ok)
      expect(body_json['schedule']).to eq(build_schedule_json(Schedule.last))
    end

    it "should not update schedule out of commercial time (on weekday)" do
      out_commercial_schedule_params = {
        schedule: {
          start_at: DateTime.now.beginning_of_day + 18.hour,
          end_at: DateTime.now.beginning_of_day + 19.hour
        }
      }

      put url, params: out_commercial_schedule_params
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "should not update schedule out of commercial time (on weekend)" do
      out_commercial_schedule_params = {
        schedule: {
          start_at: Date.today.beginning_of_week(:saturday) + 9.hour,
          end_at: Date.today.beginning_of_week(:saturday) + 9.hour
        }
      }

      put url, params: out_commercial_schedule_params
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "should not update schedule in scheduled time" do
      schedule_2 = create(:schedule,
        room: room,
        start_at: DateTime.now.beginning_of_day + 15.hour,
        end_at: DateTime.now.beginning_of_day + 16.hour
      )

      scheduled_schedule_params = {
        schedule: {
          start_at: schedule_2.start_at,
          end_at: schedule_2.end_at
        }
      }

      put url, params: scheduled_schedule_params
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "should not update schedule with end less_or_equal to start" do
      end_less_schedule_params = {
        schedule: {
          start_at: DateTime.now.beginning_of_day + 18.hour,
          end_at: DateTime.now.beginning_of_day + 17.hour
        }
      }

      put url, params: end_less_schedule_params
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context "DELETE rooms/:room_id/schedules/:id" do
    let(:schedule) { create(:schedule, room: room) }
    let(:url) { "/api/v1/rooms/#{schedule.room_id}/schedules/#{schedule.id}" }

    it "should delete schedule" do
      delete url
      expect(response).to have_http_status(:no_content)
      expect(Schedule.where(id: schedule.id).exists?).to eq(false)
    end
  end

  def build_schedule_json(schedule)
    {
      id: schedule.id,
      room_id: schedule.room_id,
      room_name: schedule.room.name,
      scheduled_by: schedule.scheduled_by,
      start_at: schedule.start_at,
      end_at: schedule.end_at,
    }.as_json
  end
end
