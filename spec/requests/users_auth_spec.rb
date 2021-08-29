require 'rails_helper'

RSpec.describe "Users Authenticated", type: :request do
  describe "User" do

    before do
      user = create(:user)
      post authenticate_path, params: { email: user[:email], password: "123456" }, :headers => @headers
      token = JSON(response.body)['auth_token']
      @headers = { "ACCEPT" => "application/json", "Authorization" => "Bearer #{token}" }
    end

    it "Get all Users" do
      get users_path, :headers => @headers
      expect(response).to have_http_status(200)
    end

    it "Show User" do
      get users_path, params: { id: 1 }, :headers => @headers
      expect(response).to have_http_status(200)
    end

    it "Update User" do
      user = User.last
      put "/users/#{user.id}", params: { name: 'José' }, :headers => @headers
      expect(response).to have_http_status(200)
    end

    it "Delete User" do
      user = User.last
      delete "/users/#{user.id}", :headers => @headers
      expect(response).to have_http_status(200)
    end


  end
end
