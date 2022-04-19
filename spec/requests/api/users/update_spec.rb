require 'rails_helper'

RSpec.describe 'User', type: :request do
  let(:user) { create(:user) }

  before(:example) do
    sign_in user
  end
  context 'Update user' do
    it 'Updating name with success' do
      old_name = user.name

      patch "/api/users/#{user.id}", params: { user: { name: Faker::Name.name } }

      expect(response).to have_http_status 200
      attributes = json_body[:data][:attributes]
      expect(attributes[:name]).not_to eq old_name
    end

    it 'Updating e-mail with success' do
      old_email = user.email

      patch "/api/users/#{user.id}", params: { user: { email: Faker::Internet.email } }

      expect(response).to have_http_status 200
      attributes = json_body[:data][:attributes]
      expect(attributes[:name]).not_to eq old_email
    end

    it "Trying to update another user's name" do
      patch "/api/users/#{create(:user).id}", params: { user: { name: Faker::Name.name } }

      expect(response).to have_http_status 422
    end

    it "Trying to update another user's e-mail" do
      patch "/api/users/#{create(:user).id}", params: { user: { email: Faker::Internet.email } }

      expect(response).to have_http_status 422
    end

    it "Trying to update user's name" do
      patch "/api/users/#{user.id}", params: { user: { name: "" } }

      expect(response).to have_http_status 422
    end
  end
end
