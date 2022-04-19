require 'rails_helper'

RSpec.describe 'User', type: :request do
  let(:user) { create(:user) }

  before(:example) do
    sign_in user
  end
  context 'Index and show' do
    it 'expect 10 users' do
      create_list(:user, 9)

      get '/api/users'

      attributes = json_body[:data]
      expect(response).to have_http_status 200
      expect(attributes.count).to eq 10
    end

    it 'expect 1 users' do
      other_user = create(:user)

      get "/api/users/#{other_user.id}"

      attributes = json_body[:data][:attributes]
      expect(response).to have_http_status 200
      expect(other_user.id).to eq (json_body[:data][:id])
      expect(other_user.name).to eq (attributes[:name])
      expect(other_user.email).to eq (attributes[:email])
    end
  end

end
