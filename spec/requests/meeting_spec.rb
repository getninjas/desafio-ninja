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
  let(:response_not_related_to_meeting) do
    { message: 'You have to belong to this meeting to do this action.' }.to_json
  end
  let(:response_not_the_meeting_owner) do
    { message: 'You have to own this meeting to do this action.' }.to_json
  end
  let(:response_no_room_available) do
    { message: 'No room available for this time.' }.to_json
  end
  let(:response_without_start_time_end_time) do
    { errors: [{ start_time: ["is missing"] }, { end_time: ["is missing"] }] }.to_json
  end
  let(:response_wrong_data_type) do
    {
      errors: [
      { start_time: ["must be a time"] },
      { end_time: ["must be a time"] },
      { users_emails: ["must be an array"] }
      ]
    }.to_json
  end
  let(:response_weekend) do
    {
      errors: [
      { start_time: ["creating events is allowed only on weekdays."] },
      { end_time: ["creating events is allowed only on weekdays."] }
      ]
    }.to_json
  end
  let(:response_before_nine_am_after_six_pm) do
    {
      errors: [
      { start_time: ["creating events is allowed only from 9am to 6pm on weekdays."] },
      { end_time: ["creating events is allowed only from 9am to 6pm on weekdays."] }
      ]
    }.to_json
  end
  let(:response_start_time_after_end_time) do
    { errors: [{ start_time: ["must be before end_time."] }] }.to_json
  end
  let(:meeting_params) do
    {
      meeting: {
        start_time: "2022-05-16T14:41:02.827Z",
        end_time: "2022-05-16T15:11:02.827Z",
        subject: "Planning",
      },
      users_emails: ["aurora@getninjas.com.br", "mariana@getninjas.com.br"]
    }
  end
  let(:meeting_params_without_start_time_end_time) do
    {
      meeting: {
        subject: "Planning",
      },
      users_emails: ["aurora@getninjas.com.br", "mariana@getninjas.com.br"]
    }
  end
  let(:meeting_params_wrong_data_type) do
    {
      meeting: {
        start_time: 1,
        end_time: 2,
      },
      users_emails: "aurora@getninjas.com.br"
    }
  end
  let(:meeting_params_weenkend) do
    {
      meeting: {
        start_time: "2022-05-15T14:41:02.827Z",
        end_time: "2022-05-15T15:11:02.827Z",
        subject: "Planning",
      },
      users_emails: ["aurora@getninjas.com.br", "mariana@getninjas.com.br"]
    }
  end
  let(:meeting_params_before_nine_am) do
    {
      meeting: {
        start_time: "2022-05-16T04:41:02.827Z",
        end_time: "2022-05-16T05:11:02.827Z",
        subject: "Planning",
      },
      users_emails: ["aurora@getninjas.com.br", "mariana@getninjas.com.br"]
    }
  end
  let(:meeting_params_after_six_pm) do
    {
      meeting: {
        start_time: "2022-05-16T19:41:02.827Z",
        end_time: "2022-05-16T20:11:02.827Z",
        subject: "Planning",
      },
      users_emails: ["aurora@getninjas.com.br", "mariana@getninjas.com.br"]
    }
  end
  let(:meeting_params_start_time_after_end_time) do
    {
      meeting: {
        start_time: "2022-05-16T10:11:02.827Z",
        end_time: "2022-05-16T09:41:02.827Z",
        subject: "Planning",
      },
      users_emails: ["aurora@getninjas.com.br", "mariana@getninjas.com.br"]
    }
  end
  let(:meeting_params_update_guest_subject) do
    {
      meeting: {
        start_time: "2022-05-16T14:41:02.827Z",
        end_time: "2022-05-16T15:11:02.827Z",
        subject: "Weekly"
      },
      users_emails: ["aurora@getninjas.com.br", "mariana@getninjas.com.br"]
    }
  end
  let(:meeting_params_update_timmings) do
    {
      meeting: {
        start_time: "2022-05-16T16:41:02.827Z",
        end_time: "2022-05-16T17:11:02.827Z"
      }
    }
  end
  let(:meeting_params_update_timmings_conflict) do
    {
      meeting: {
        start_time: "2022-05-16T14:41:02.827Z",
        end_time: "2022-05-16T15:11:02.827Z"
      }
    }
  end

  before(:each) do
    @current_user = create(:user)
    login
    @auth_params = get_auth_params_from_login_response_headers(response)
  end

  context 'validations' do
    context 'when there is no start_time and end_time' do
      it 'returns info message and http bad_request' do
        post api_meeting_index_path, params: meeting_params_without_start_time_end_time, headers: @auth_params

        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq(response_without_start_time_end_time)
      end
    end

    context 'when payload attributes has wrong data types' do
      it 'returns info message and http bad_request' do
        post api_meeting_index_path, params: meeting_params_wrong_data_type, headers: @auth_params

        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq(response_wrong_data_type)
      end
    end

    context 'when start_time and end_time are not set on weekdays' do
      it 'returns info message and http bad_request' do
        post api_meeting_index_path, params: meeting_params_weenkend, headers: @auth_params

        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq(response_weekend)
      end
    end

    context 'when start_time and end_time are before 9am' do
      it 'returns info message and http bad_request' do
        post api_meeting_index_path, params: meeting_params_before_nine_am, headers: @auth_params

        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq(response_before_nine_am_after_six_pm)
      end
    end

    context 'when start_time and end_time are after 6pm' do
      it 'returns info message and http bad_request' do
        post api_meeting_index_path, params: meeting_params_after_six_pm, headers: @auth_params

        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq(response_before_nine_am_after_six_pm)
      end
    end

    context 'when start_time comes after end_time' do
      it 'returns info message and http bad_request' do
        post api_meeting_index_path, params: meeting_params_start_time_after_end_time, headers: @auth_params

        expect(response).to have_http_status(:bad_request)

        expect(response.body).to eq(response_start_time_after_end_time)
      end
    end
  end

  describe "GET /api/my_created_meetings" do
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
        invited_user = create(:user, name: 'Aurora', email: 'aurora@getninjas.com.br')
        other_invited_user = create(:user, name: 'Mariana', email: 'mariana@getninjas.com.br')
        meeting.users << [invited_user, other_invited_user]

        get api_my_created_meetings_path, headers: @auth_params

        data = JSON.parse(response.body, symbolize_names: true)
        meeting_data = data[:my_created_meetings].first
        expect(response).to have_http_status(:success)
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

  describe "GET /api/my_meetings_invitations" do
    context "when user does not have any invited meetings" do
      it "returns http success" do
        get api_my_meetings_invitations_path, headers: @auth_params

        expect(response).to have_http_status(:success)
        expect(response.body). to eq(response_empty_invited_meetings)
      end
    end

    context "when user has an invited meeting" do
      it "returns an info message and http success" do
        meeting_owner = create(:user, name: 'Mariana', email: 'mariana@getninjas.com.br')
        meeting = create(:meeting, user_id: meeting_owner.id)
        invited_user = create(:user, name: 'Aurora', email: 'aurora@getninjas.com.br')
        meeting.users << [invited_user, @current_user]

        get api_my_meetings_invitations_path, headers: @auth_params

        data = JSON.parse(response.body, symbolize_names: true)
        meeting_data = data[:my_meetings_invitations].first
        expect(response).to have_http_status(:success)
        expect(date_formatter(meeting_data[:start_time])).to eq(meeting.start_time.strftime("%H:%M %d/%m/%Y"))
        expect(date_formatter(meeting_data[:end_time])).to eq(meeting.end_time.strftime("%H:%M %d/%m/%Y"))
        expect(meeting_data[:room]).to eq(meeting.room.name)
        expect(meeting_data[:owner_name]).to eq(meeting.owner.name)
        expect(meeting_data[:owner_email]).to eq(meeting.owner.email)
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

  describe "GET /api/meeting/:id" do
    context 'when user is not related to the meeting' do
      it "returns an info message and http forbidden" do
        meeting_owner = create(:user, name: 'Mariana', email: 'mariana@getninjas.com.br')
        meeting = create(:meeting, user_id: meeting_owner.id)
        invited_user = create(:user, name: 'Aurora', email: 'aurora@getninjas.com.br')
        meeting.users << invited_user

        get api_meeting_path(meeting.id), headers: @auth_params

        expect(response).to have_http_status(:forbidden)
        expect(response.body).to eq(response_not_related_to_meeting)
      end
    end

    context 'when meeting does not exist' do
      it "returns http not_found" do
        get api_meeting_path(666), headers: @auth_params

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when meeting exists and it is related to user' do
      it "returns http success" do
        meeting_owner = create(:user, name: 'Mariana', email: 'mariana@getninjas.com.br')
        meeting = create(:meeting, user_id: meeting_owner.id)
        invited_user = create(:user, name: 'Aurora', email: 'aurora@getninjas.com.br')
        meeting.users << [invited_user, @current_user]

        get api_meeting_path(meeting.id), headers: @auth_params

        expect(response).to have_http_status(:success)
        meeting_data = JSON.parse(response.body, symbolize_names: true)
        expect(meeting_data[:id]).to eq(meeting.id)
        expect(date_formatter(meeting_data[:start_time])).to eq(meeting.start_time.strftime("%H:%M %d/%m/%Y"))
        expect(date_formatter(meeting_data[:end_time])).to eq(meeting.end_time.strftime("%H:%M %d/%m/%Y"))
        expect(meeting_data[:owner_name]).to eq(meeting.owner.name)
        expect(meeting_data[:owner_email]).to eq(meeting.owner.email)
        expect(meeting_data[:room]).to eq(meeting.room.name)
        expect(meeting_data[:subject]).to eq(meeting.subject)
        expect(meeting_data[:participants]).to match_array(
          [
            { name: @current_user.name, email: @current_user.email },
            { name: invited_user.name, email: invited_user.email }
          ]
        )
      end
    end
  end

  describe "POST /api/meeting" do
    context 'when there is four rooms available' do
      it 'creates a meeting in Room 1, returns meeting data and http success' do
        invited_user = create(:user, name: 'Mariana', email: 'mariana@getninjas.com.br')
        other_invited_user = create(:user, name: 'Aurora', email: 'aurora@getninjas.com.br')
        room_one = create(:room, name: 'Sala 1')
        create(:room, name: 'Sala 2')
        create(:room, name: 'Sala 3')
        create(:room, name: 'Sala 4')
        expect(Meeting.all.count).to be_zero

        post api_meeting_index_path, params: meeting_params, headers: @auth_params

        data = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:success)
        expect(data[:start_time]).to eq(meeting_params[:meeting][:start_time])
        expect(data[:end_time]).to eq(meeting_params[:meeting][:end_time])
        expect(data[:room]).to eq(room_one.name)
        expect(data[:owner_name]).to eq(@current_user.name)
        expect(data[:owner_email]).to eq(@current_user.email)
        expect(data[:subject]).to eq(meeting_params[:meeting][:subject])
        expect(data[:participants]).to match_array(
          [
            { email: invited_user.email, name: invited_user.name },
            { email: other_invited_user.email, name: other_invited_user.name }
          ]
        )
        expect(Meeting.all.count).to be(1)
      end
    end

    context 'when there is three rooms available' do
      it 'creates a meeting in Room 2, returns meeting data and http success' do
        invited_user = create(:user, name: 'Mariana', email: 'mariana@getninjas.com.br')
        other_invited_user = create(:user, name: 'Aurora', email: 'aurora@getninjas.com.br')
        room_one = create(:room, name: 'Sala 1')
        room_two = create(:room, name: 'Sala 2')
        create(:room, name: 'Sala 3')
        create(:room, name: 'Sala 4')
        create(:meeting, user_id: @current_user.id, room_id: room_one.id)
        expect(Meeting.all.count).to be(1)

        post api_meeting_index_path, params: meeting_params, headers: @auth_params

        data = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:success)
        expect(data[:start_time]).to eq(meeting_params[:meeting][:start_time])
        expect(data[:end_time]).to eq(meeting_params[:meeting][:end_time])
        expect(data[:room]).to eq(room_two.name)
        expect(data[:owner_name]).to eq(@current_user.name)
        expect(data[:owner_email]).to eq(@current_user.email)
        expect(data[:subject]).to eq(meeting_params[:meeting][:subject])
        expect(data[:participants]).to match_array(
          [
            { email: invited_user.email, name: invited_user.name },
            { email: other_invited_user.email, name: other_invited_user.name }
          ]
        )
        expect(Meeting.all.count).to be(2)
      end
    end

    context 'when there is two rooms available' do
      it 'creates a meeting in Room 3, returns meeting data and http success' do
        invited_user = create(:user, name: 'Mariana', email: 'mariana@getninjas.com.br')
        other_invited_user = create(:user, name: 'Aurora', email: 'aurora@getninjas.com.br')
        room_one = create(:room, name: 'Sala 1')
        room_two = create(:room, name: 'Sala 2')
        room_three = create(:room, name: 'Sala 3')
        create(:room, name: 'Sala 4')
        create(:meeting, user_id: @current_user.id, room_id: room_one.id)
        create(:meeting, user_id: @current_user.id, room_id: room_two.id)
        expect(Meeting.all.count).to be(2)

        post api_meeting_index_path, params: meeting_params, headers: @auth_params

        data = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:success)
        expect(data[:start_time]).to eq(meeting_params[:meeting][:start_time])
        expect(data[:end_time]).to eq(meeting_params[:meeting][:end_time])
        expect(data[:room]).to eq(room_three.name)
        expect(data[:owner_name]).to eq(@current_user.name)
        expect(data[:owner_email]).to eq(@current_user.email)
        expect(data[:subject]).to eq(meeting_params[:meeting][:subject])
        expect(data[:participants]).to match_array(
          [
            { email: invited_user.email, name: invited_user.name },
            { email: other_invited_user.email, name: other_invited_user.name }
          ]
        )
        expect(Meeting.all.count).to be(3)
      end
    end

    context 'when there is one room available' do
      it 'creates a meeting in Room 4, returns meeting data and http success' do
        invited_user = create(:user, name: 'Mariana', email: 'mariana@getninjas.com.br')
        other_invited_user = create(:user, name: 'Aurora', email: 'aurora@getninjas.com.br')
        room_one = create(:room, name: 'Sala 1')
        room_two = create(:room, name: 'Sala 2')
        room_three = create(:room, name: 'Sala 3')
        room_four = create(:room, name: 'Sala 4')
        create(:meeting, user_id: @current_user.id, room_id: room_one.id)
        create(:meeting, user_id: @current_user.id, room_id: room_two.id)
        create(:meeting, user_id: @current_user.id, room_id: room_three.id)
        expect(Meeting.all.count).to be(3)

        post api_meeting_index_path, params: meeting_params, headers: @auth_params

        data = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:success)
        expect(data[:start_time]).to eq(meeting_params[:meeting][:start_time])
        expect(data[:end_time]).to eq(meeting_params[:meeting][:end_time])
        expect(data[:room]).to eq(room_four.name)
        expect(data[:owner_name]).to eq(@current_user.name)
        expect(data[:owner_email]).to eq(@current_user.email)
        expect(data[:subject]).to eq(meeting_params[:meeting][:subject])
        expect(data[:participants]).to match_array(
          [
            { email: invited_user.email, name: invited_user.name },
            { email: other_invited_user.email, name: other_invited_user.name }
          ]
        )
        expect(Meeting.all.count).to be(4)
      end
    end

    context 'when there is no room available' do
      it 'returns info message and http success' do
        create(:user, name: 'Mariana', email: 'mariana@getninjas.com.br')
        create(:user, name: 'Aurora', email: 'aurora@getninjas.com.br')
        room_one = create(:room, name: 'Sala 1')
        room_two = create(:room, name: 'Sala 2')
        room_three = create(:room, name: 'Sala 3')
        room_four = create(:room, name: 'Sala 4')
        create(:meeting, user_id: @current_user.id, room_id: room_one.id)
        create(:meeting, user_id: @current_user.id, room_id: room_two.id)
        create(:meeting, user_id: @current_user.id, room_id: room_three.id)
        create(:meeting, user_id: @current_user.id, room_id: room_four.id)
        expect(Meeting.all.count).to be(4)

        post api_meeting_index_path, params: meeting_params, headers: @auth_params

        expect(response).to have_http_status(:success)
        expect(response.body).to eq(response_no_room_available)
        expect(Meeting.all.count).to be(4)
      end
    end
  end

  describe "PUT /api/meeting/:id" do
    context 'when the user is not the meeting owner' do
      it "does not updates the meeting returns http fprbidden" do
        meeting_owner = create(:user, name: 'Mariana', email: 'mariana@getninjas.com.br')
        meeting = create(:meeting, user_id: meeting_owner.id)
        invited_user = create(:user, name: 'Aurora', email: 'aurora@getninjas.com.br')
        meeting.users << invited_user

        put "/api/meeting/#{meeting.id}", params: meeting_params_update_guest_subject, headers: @auth_params

        expect(response).to have_http_status(:forbidden)
        expect(meeting.subject).to_not eq(meeting_params_update_guest_subject[:subject])
        expect(meeting.users.map(&:email)).to_not eq(meeting_params_update_guest_subject[:users_emails])
      end
    end

    context 'when there is only subject and guests to update' do
      it "updates meeting returns http success" do
        to_be_invited = create(:user, name: 'Mariana', email: 'mariana@getninjas.com.br')
        meeting = create(:meeting, user_id: @current_user.id)
        invited_user = create(:user, name: 'Aurora', email: 'aurora@getninjas.com.br')
        meeting.users << invited_user
        expect(Meeting.all.count).to eq(1)

        put "/api/meeting/#{meeting.id}", params: meeting_params_update_guest_subject, headers: @auth_params
        meeting.reload
        expect(response).to have_http_status(:success)
        expect(meeting.subject).to eq(meeting_params_update_guest_subject[:meeting][:subject])
        expect(meeting.users.map(&:email)).to match_array([invited_user.email, to_be_invited.email])
        expect(Meeting.all.count).to eq(1)
      end
    end

    context 'when there is only meeting timmings to update' do
      it "updates meeting returns http success" do
        meeting = create(:meeting, user_id: @current_user.id)
        invited_user = create(:user, name: 'Aurora', email: 'aurora@getninjas.com.br')
        meeting.users << invited_user
        expect(Meeting.all.count).to eq(1)

        put "/api/meeting/#{meeting.id}", params: meeting_params_update_timmings, headers: @auth_params
        meeting.reload
        expect(response).to have_http_status(:success)
        expect(meeting.start_time.strftime("%H:%M %d/%m/%Y")).to eq(
          date_formatter(meeting_params_update_timmings[:meeting][:start_time])
        )
        expect(meeting.end_time.strftime("%H:%M %d/%m/%Y")).to eq(
          date_formatter(meeting_params_update_timmings[:meeting][:end_time])
        )
        expect(Meeting.all.count).to eq(1)
      end
    end

    context 'when there is room available to new timmings' do
      it "updates meeting returns http success" do
        room_one = create(:room, name: 'Sala 1')
        room_two = create(:room, name: 'Sala 2')
        room_three = create(:room, name: 'Sala 3')
        room_four = create(:room, name: 'Sala 4')
        create(:meeting, user_id: @current_user.id, room_id: room_one.id)
        create(:meeting, user_id: @current_user.id, room_id: room_two.id)
        create(:meeting, user_id: @current_user.id, room_id: room_three.id)
        create(:meeting, user_id: @current_user.id, room_id: room_four.id)
        meeting = create(
          :meeting,
          user_id: @current_user.id,
          start_time: '2022-05-16T16:41:02.827Z',
          end_time: '2022-05-16T17:41:02.827Z',
          room_id: room_one.id
        )
        invited_user = create(:user, name: 'Aurora', email: 'aurora@getninjas.com.br')
        meeting.users << invited_user
        expect(Meeting.all.count).to be(5)

        put "/api/meeting/#{meeting.id}", params: meeting_params_update_timmings_conflict, headers: @auth_params

        expect(response).to have_http_status(:success)
        expect(response.body).to eq(response_no_room_available)
        expect(Meeting.all.count).to eq(5)
      end
    end

    context 'when meeting does not exist' do
      it "returns http not_found" do
        put "/api/meeting/666", params: meeting_params_update_guest_subject, headers: @auth_params

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /api/meeting/:id" do
    context 'when meeting does not exist' do
      it "returns http not_found" do
        delete "/api/meeting/666", headers: @auth_params

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user is not the meeting owner' do
      it "returns an info message and http forbidden" do
        meeting_owner = create(:user, name: 'Mariana', email: 'mariana@getninjas.com.br')
        meeting = create(:meeting, user_id: meeting_owner.id)

        delete "/api/meeting/#{meeting.id}", headers: @auth_params

        expect(response).to have_http_status(:forbidden)
        expect(response.body).to eq(response_not_the_meeting_owner)
      end
    end

    context 'when user is the meeting owner' do
      it 'returns http success' do
        meeting = create(:meeting, user_id: @current_user.id)
        invited_user = create(:user, name: 'Aurora', email: 'aurora@getninjas.com.br')
        other_invited_user = create(:user, name: 'Mariana', email: 'mariana@getninjas.com.br')
        meeting.users << [invited_user, other_invited_user]

        delete "/api/meeting/#{meeting.id}", headers: @auth_params

        expect(response).to have_http_status(:success)
        expect(Meeting.all.count).to be_zero
      end
    end
  end

  def login
    post api_user_session_path, params: { email: @current_user.email, password: 'password' }.to_json,
                                headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
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
