require "rails_helper"

RSpec.describe "Rack::Attack", type: :request do
  include ActiveSupport::Testing::TimeHelpers
  let!(:blocked_ip) { "204.15.20.0" }

  before do
    Rack::Attack.enabled = true
    Rack::Attack.reset!
    Rack::Attack.blocklist_ip(blocked_ip)
  end

  after do
    Rack::Attack.enabled = false
  end

  describe "POST rooms/:room_id/schedules" do
    let(:room) { create(:room) }
    let(:schedule_params) { create(:schedule, room: room) }
    let(:url) { "/api/v1/rooms/#{room.id}/schedules" }

    it "successful for 5 requests, then blocks the user" do
      headers = {"REMOTE_ADDR" => "1.2.3.4"}

      5.times do
        get url, headers: headers
        expect(response).to have_http_status(:ok)
      end

      get url, headers: headers
      expect(response.body).to include("Retry later")
      expect(response).to have_http_status(:too_many_requests)

      travel_to(5.seconds.from_now) do
        get url, headers: headers
        expect(response).to have_http_status(:ok)
      end
    end

    it "Does not allow access to blocked IP address" do
      headers = {"REMOTE_ADDR" => "204.15.20.0"}
      get url, headers: headers
      expect(response.body).to include("Forbidden")
      expect(response).to have_http_status(:forbidden)
    end
  end
end
