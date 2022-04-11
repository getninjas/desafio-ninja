# frozen_string_literal: true

require 'rails_helper'

shared_examples 'have http status' do |status|
  it 'returns correct http status' do
    expect(response).to have_http_status(status)
  end
end

shared_examples 'have http status with error' do |status, error|
  include_examples 'have http status', status

  it 'returns correct error' do
    expect(json_response['error']).to include(error)
  end
end

describe "api/schedules", type: :request do
  describe "GET /api/schedules" do
    let(:request!) { get "/api/schedules" }

    before(:each) { request! }

    include_examples 'have http status', :ok, skip_request: true
  end

  describe "POST /api/schedules" do
    let(:request!) { post "/api/schedules", params: attributes }
    let!(:room_id) { create(:room).id }
    let(:attributes) do
      {
        title: "doesn't matter",
        date: Date.today,
        start_hour: 1,
        end_hour: 2,
        room_id: room_id
      }
    end

    before(:each) { request! }

    include_examples 'have http status', :ok, skip_request: true
  end

  describe "DELETE /api/schedules" do
    let(:request!) { delete "/api/schedules/#{schedule_id}" }
    let(:schedule_id) { create(:schedule).id }

    before(:each) { request! }

    include_examples 'have http status', :no_content, skip_request: true
  end

  describe "PUT /api/schedules" do
    let(:request!) { put "/api/schedules/#{schedule_id}", params: attributes }

    let!(:schedule_id) { create(:schedule).id }
    let(:attributes) do
      {
        title: "doesn't matter"
      }
    end

    before(:each) { request! }

    include_examples 'have http status', :ok, skip_request: true
  end
end
