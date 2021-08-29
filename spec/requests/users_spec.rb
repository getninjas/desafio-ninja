require 'rails_helper'

RSpec.describe "Users not Authenticated", type: :request do
  describe "User - POST" do

    it "Create User" do
      user = attributes_for(:user)
      post users_path, params: user, :headers => { "ACCEPT" => "application/json" }
      expect(response).to have_http_status(201)
    end


  end
end
