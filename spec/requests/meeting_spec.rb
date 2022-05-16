require 'rails_helper'
require 'webmock/rspec'
include ActionController::RespondWith

RSpec.describe "Meetings", type: :request do
  let(:response_empty_created_meetings) do
    { message: "You don't have created meetings yet." }.to_json
  end
  let(:response_empty_invited_meetings) do
    { message: "You don't have any inveted meetings yet." }.to_json
  end

  before(:each) do
    @current_user = create(:user)
    login
    @auth_params = get_auth_params_from_login_response_headers(response)
  end

  describe "GET /my_created_meetings" do
    context "when user does not have any created meetings" do
      it "returns an info message and http success" do
        get api_my_created_meetings_path, headers: @auth_params

        expect(response).to have_http_status(:success)
        expect(response.body). to eq(response_empty_created_meetings)
      end
    end

    context "when user has a created meeting" do
      it "returns an info message and http success" do
        meeting = create(:meeting, user_id: @current_user.id)
        invited_user = create(:user, name: 'Aurora', email: 'aurora@email.com')
        other_invited_user = create(:user, name: 'Mariana', email: 'mariana@email.com')
        meeting.users << [invited_user, other_invited_user]
        get api_my_created_meetings_path, headers: @auth_params

        expect(response).to have_http_status(:success)

        data = JSON.parse(response.body, symbolize_names: true)
        meeting_data = data[:my_created_meetings].first
        expect(date_formatter(meeting_data[:start_time])).to eq(meeting.start_time.strftime("%H:%M %d/%m/%Y"))
        expect(date_formatter(meeting_data[:end_time])).to eq(meeting.end_time.strftime("%H:%M %d/%m/%Y"))
        expect(meeting_data[:room]).to eq(meeting.room.name)
        expect(meeting_data[:subject]).to eq(meeting.subject)
        expect(meeting_data[:participants]).to match_array(
          [
            { email: invited_user.email, name: invited_user.name },
            { email: other_invited_user.email, name: other_invited_user.name }
          ]
        )
      end
    end
  end

  describe "GET /my_meetings_invitations" do
    context "when user does not have any invited meetings" do
      it "returns http success" do
        get api_my_meetings_invitations_path, headers: @auth_params

        expect(response).to have_http_status(:success)
        expect(response.body). to eq(response_empty_invited_meetings)
      end
    end

    context "when user has an invited meeting" do
      it "returns an info message and http success" do
        meeting_owner = create(:user, name: 'Mariana', email: 'mariana@email.com')
        meeting = create(:meeting, user_id: meeting_owner.id)
        invited_user = create(:user, name: 'Aurora', email: 'aurora@email.com')
        meeting.users << [invited_user, @current_user]
        get api_my_meetings_invitations_path, headers: @auth_params

        expect(response).to have_http_status(:success)

        data = JSON.parse(response.body, symbolize_names: true)
        meeting_data = data[:my_meetings_invitations].first
        expect(date_formatter(meeting_data[:start_time])).to eq(meeting.start_time.strftime("%H:%M %d/%m/%Y"))
        expect(date_formatter(meeting_data[:end_time])).to eq(meeting.end_time.strftime("%H:%M %d/%m/%Y"))
        expect(meeting_data[:room]).to eq(meeting.room.name)
        expect(meeting_data[:owner_name]).to eq(meeting_owner.name)
        expect(meeting_data[:owner_email]).to eq(meeting_owner.email)
        expect(meeting_data[:subject]).to eq(meeting.subject)
        expect(meeting_data[:participants]).to match_array(
          [
            { email: @current_user.email, name: @current_user.name },
            { email: invited_user.email, name: invited_user.name }
          ]
        )
      end
    end
  end

  describe "GET /delete" do
    it "returns http success" do
      get "/meeting/delete"
      expect(response).to have_http_status(:success)

  def login
    post api_user_session_path, params:  { email: @current_user.email, password: 'password' }.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  end

  def get_auth_params_from_login_response_headers(response)
    client = response.headers['client']
    token = response.headers['access-token']
    expiry = response.headers['expiry']
    token_type = response.headers['token-type']
    uid = response.headers['uid']

    auth_params = {
      'access-token' => token,
      'client' => client,
      'uid' => uid,
      'expiry' => expiry,
      'token-type' => token_type
    }
    auth_params
  end

  def date_formatter(date)
    DateTime.parse(date).strftime("%H:%M %d/%m/%Y")
  end
end
