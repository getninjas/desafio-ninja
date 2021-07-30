require 'rails_helper'

RSpec.describe "Api::V1::Schedules", type: :request do

  context "GET rooms/:room_id/schedules" do
    let(:room) { create(:room) }
    let(:schedules) { create_list(:schedule, rand(0..5), room: room) }
    let(:url) { "/api/v1/rooms/#{room.id}/schedules" }

    it "should return success status" do
      get url
      expect(response).to have_http_status(:ok)
    end

    it "should return all schedules from room" do
      get url
      expect(body_json['schedules'].count).to eq(room.schedules.count)
      expect(body_json['schedules']).to be_sorted(by: :scheduled_at)
    end

    it "should return not found status when room does not exists" do
      url = "/api/v1/rooms/#{Faker::Crypto.md5}/schedules"
      get url
      expect(response).to have_http_status(:not_found)
    end
  end

  context "GET rooms/:room_id/schedules/:id" do
    let(:room) { create(:room) }
    let(:schedules) { create_list(:schedule, rand(1..5), room: room) }
    let(:schedule_sample) { schedules.sample }
    let(:url) { "/api/v1/rooms/#{room.id}/schedules/#{schedule_sample.id}" }

    it "should return success status" do
      get url
      expect(response).to have_http_status(:ok)
    end

    it "should return schedule" do
      get url
      expect(body_json['schedules']).to eq(schedule_sample)
    end

    it "should return not found status when schedule does not exists" do
      url = "/api/v1/rooms/#{room.id}/schedules/#{Faker::Crypto.md5}"
      get url
      expect(response).to have_http_status(:not_found)
    end
  end

  context "POST rooms/:room_id/schedules" do
    let(:room) { create(:room) }
    let(:schedule) { create(:schedule, room: room) }
    let(:url) { "/api/v1/rooms/#{room.id}/schedules" }

    let(:schedule_params) {{
      schedule: {
        scheduled_by: Faker::Name.name,
        start_at: schedule.start_at + 3.hour,
        end_at: schedule.end_at + 4.hour
      }.to_json
    }}

    let(:end_less_schedule_params) {{
      schedule: {
        scheduled_by: Faker::Name.name,
        start_at: schedule.start_at + 4.hour,
        end_at: schedule.end_at + rand(3..4).hour
      }.to_json
    }}

    let(:scheduled_schedule_params) {{
      schedule: {
        scheduled_by: Faker::Name.name,
        start_at: schedule.start_at,
        end_at: schedule.end_at
      }.to_json
    }}

    let(:out_commercial_schedule_params) {{
      schedule: {
        scheduled_by: Faker::Name.name,
        start_at: Faker::Time.between_dates(from: Date.today, to: Date.today, period: :midnight),
        end_at: Faker::Time.between_dates(from: Date.today, to: Date.today, period: :midnight) + 1.hour
      }.to_json
    }}

    it "should return success status" do
      post url, params: schedule_params
      expect(response).to have_http_status(:ok)
    end

    it "should create schedule in commercial time" do
      post url, params: schedule_params
      expect(body_json['schedule']).to eq(Schedule.last.as_json)
    end

    it "should not create schedule out of commercial time" do
      post url, params: out_commercial_schedule_params
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "should not create schedule in scheduled time" do
      post url, params: scheduled_schedule_params
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "should not create schedule with end less_or_equal to start" do
      post url, params: end_less_schedule_params
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context "PUT rooms/:room_id/schedules/:id" do
    let(:room) { create(:room) }
    let(:schedule) { create(:schedule, room: room) }
    let(:url) { "/api/v1/rooms/#{room.id}/schedules" }
    let(:schedule_params) {{
      schedule: {
        start_at: schedule.start_at + 3.hour,
        end_at: schedule.end_at + 4.hour
      }.to_json
    }}

    let(:end_less_schedule_params) {{
      schedule: {
        start_at: schedule.start_at + 4.hour,
        end_at: schedule.end_at + rand(3..4).hour
      }.to_json
    }}

    let(:scheduled_schedule_params) {{
      schedule: {
        start_at: schedule.start_at,
        end_at: schedule.end_at
      }.to_json
    }}

    let(:out_commercial_schedule_params) {{
      schedule: {
        start_at: Faker::Time.between_dates(from: Date.today, to: Date.today, period: :midnight),
        end_at: Faker::Time.between_dates(from: Date.today, to: Date.today, period: :midnight) + 1.hour
      }.to_json
    }}

    it "should return success status" do
      put url, params: schedule_params
      expect(response).to have_http_status(:ok)
    end

    it "should update schedule" do
      put url, params: schedule_params
      expect(body_json['schedule']).to eq(Schedule.last.as_json)
    end

    it "should not update schedule out of commercial time" do
      put url, params: out_commercial_schedule_params
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "should not update schedule in scheduled time" do
      put url, params: scheduled_schedule_params
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "should not update schedule with end less_or_equal to start" do
      put url, params: end_less_schedule_params
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context "DELETE rooms/:room_id/schedules/:id" do
    let(:room) { create(:room) }
    let(:schedules) { create_list(:schedule, rand(1..5), room: room) }
    let(:schedule_sample) { schedules.sample }
    let(:url) { "/api/v1/rooms/#{room.id}/schedules/#{schedule_sample.id}" }

    it "should return success status" do
      delete url
      expect(response).to have_http_status(:ok)
    end

    it "should delete schedule" do
      delete url
      expect(Schedule.where(id: schedule_sample.id).exists?).to eq(false)
    end
  end
end
