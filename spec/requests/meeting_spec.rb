require 'rails_helper'

RSpec.describe "Meetings", type: :request do
  describe "GET /my_meetings" do
    it "returns http success" do
      get "/my_meetings"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/meeting/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/meeting/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/meeting/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /delete" do
    it "returns http success" do
      get "/meeting/delete"
      expect(response).to have_http_status(:success)
    end
  end

end
