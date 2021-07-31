require 'rails_helper'

RSpec.describe "Api::V1::Schedules", type: :request do
  let(:room) { create(:room) }

  context "GET rooms/:room_id/schedules" do
    let(:schedules) { create_list(:schedule, rand(1..5), room: room) }
    let(:url) { "/api/v1/rooms/#{room.id}/schedules" }

    it "should return all schedules from room" do
      get url
      expect(response).to have_http_status(:ok)
      expect(body_json['schedules'].count).to eq(room.schedules.count)
    end

    it "should return not found status when room does not exists" do
      url = "/api/v1/rooms/#{Faker::Crypto.md5}/schedules"
      get url
      expect(response).to have_http_status(:not_found)
      expect(response.message).to eq("Not Found")
    end
  end

  context "GET rooms/:room_id/schedules/:id" do
    let(:schedules) { create_list(:schedule, rand(1..5), room: room) }
    let(:schedule_sample) { schedules.sample }
    let(:url) { "/api/v1/rooms/#{room.id}/schedules/#{schedule_sample.id}" }

    it "should return schedule" do
      get url
      expect(response).to have_http_status(:ok)
      expect(body_json['schedule']).to eq(build_schedule_json(Schedule.find(schedule_sample.id)))
    end

    it "should return not found status when schedule does not exists" do
      url = "/api/v1/rooms/#{room.id}/schedules/#{Faker::Crypto.md5}"
      get url
      expect(response).to have_http_status(:not_found)
      expect(response.message).to eq("Not Found")
    end
  end

  context "POST rooms/:room_id/schedules" do
    let(:room) { create(:room) }
    let(:schedule) { create(:schedule, room: room) }
    let(:url) { "/api/v1/rooms/#{room.id}/schedules" }

    it "should create schedule in commercial time" do
      schedule_params = {
        schedule: {
          scheduled_by: Faker::Name.name,
          start_at: schedule.start_at + 3.hour,
          end_at: schedule.end_at + 4.hour
        }
      }

      post url, params: schedule_params
      expect(response).to have_http_status(:ok)
      expect(body_json['schedule']).to eq(build_schedule_json(Schedule.last))
    end

    it "should not create schedule out of commercial time" do
      out_commercial_schedule_params = {
        schedule: {
          scheduled_by: Faker::Name.name,
          start_at: Faker::Time.between_dates(from: Date.today, to: Date.today, period: :midnight),
          end_at: Faker::Time.between_dates(from: Date.today, to: Date.today, period: :midnight) + 1.hour
        }
      }

      post url, params: out_commercial_schedule_params
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "should not create schedule in scheduled time" do
      scheduled_schedule_params = {
        schedule: {
          scheduled_by: Faker::Name.name,
          start_at: schedule.start_at,
          end_at: schedule.end_at
        }
      }

      post url, params: scheduled_schedule_params
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "should not create schedule with end less_or_equal to start" do
      end_less_schedule_params = {
        schedule: {
          scheduled_by: Faker::Name.name,
          start_at: schedule.start_at + 4.hour,
          end_at: schedule.end_at + rand(3..4).hour
        }
      }

      post url, params: end_less_schedule_params
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context "PUT rooms/:room_id/schedules/:id" do
    let(:schedule) { create(:schedule, room: room) }
    let(:url) { "/api/v1/rooms/#{room.id}/schedules/#{schedule.id}" }

    it "should update schedule" do
      schedule_params = {
        schedule: {
          start_at: schedule.start_at + 1.hour,
          end_at: schedule.end_at + 2.hour
        }
      }

      put url, params: schedule_params
      expect(response).to have_http_status(:ok)
      expect(body_json['schedule']).to eq(build_schedule_json(Schedule.last))
    end

    it "should not update schedule out of commercial time" do
      out_commercial_schedule_params = {
        schedule: {
          start_at: Faker::Time.between_dates(from: Date.today, to: Date.today, period: :midnight),
          end_at: Faker::Time.between_dates(from: Date.today, to: Date.today, period: :midnight) + 1.hour
        }
      }

      put url, params: out_commercial_schedule_params
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "should not update schedule in scheduled time" do
      scheduled_schedule_params = {
        schedule: {
          start_at: schedule.start_at,
          end_at: schedule.end_at
        }
      }

      put url, params: scheduled_schedule_params
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "should not update schedule with end less_or_equal to start" do
      end_less_schedule_params = {
        schedule: {
          start_at: schedule.start_at + 4.hour,
          end_at: schedule.end_at + rand(3..4).hour
        }
      }

      put url, params: end_less_schedule_params
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context "DELETE rooms/:room_id/schedules/:id" do
    let(:schedules) { create_list(:schedule, rand(1..5), room: room) }
    let(:schedule_sample) { schedules.sample }
    let(:url) { "/api/v1/rooms/#{room.id}/schedules/#{schedule_sample.id}" }

    it "should delete schedule" do
      delete url
      expect(response).to have_http_status(:no_content)
      expect(Schedule.where(id: schedule_sample.id).exists?).to eq(false)
    end
  end

  def build_schedule_json(schedule)
    {
      id: schedule.id,
      room_id: schedule.room.id,
      room_name: schedule.room.name,
      scheduled_by: schedule.scheduled_by,
      start_at: schedule.start_at,
      end_at: schedule.end_at,
    }.as_json
  end
end
