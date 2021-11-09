require 'rails_helper'

RSpec.describe "Auths", type: :request do
  describe "POST /token" do
    let(:perform) { post "/auth/token", params: params }

    context 'when user_email is empty' do
      let(:params) { { password: 'password' } }

      it 'returns bad request' do
        perform

        expect(response.status).to eq(400)
      end

      it 'returns error message' do
        perform

        expect(response.body).to eq({
          error: {
            message: 'user_email must not be empty'
          }
        }.to_json)
      end
    end

    context 'when password is not empty' do
      let(:params) { { user_email: 'email@email.com' } }

      it 'returns bad request' do
        perform

        expect(response.status).to eq(400)
      end

      it 'returns error message' do
        perform

        expect(response.body).to eq({
          error: {
            message: 'password must not be empty'
          }
        }.to_json)
      end
    end

    context 'when the user is not found' do
      let(:params) do
        {
          user_email: 'invalid',
          password: 'password'
        }
      end

      it 'returns bad request' do
        perform

        expect(response.status).to eq(400)
      end

      it 'returns error message' do
        perform

        expect(response.body).to eq({
          error: {
            message: 'user_email or password is not valid'
          }
        }.to_json)
      end
    end

    context 'whe the user exists' do
      let(:user) { create(:user, password: password) }
      let(:password) { Faker::App.name }

      context 'but the password is invalid' do
        let(:params) do
          {
            user_email: user.email,
            password: 'password'
          }
        end

        it 'returns bad request' do
          perform

          expect(response.status).to eq(400)
        end

        it 'returns error message' do
          perform

          expect(response.body).to eq({
            error: {
              message: 'user_email or password is not valid'
            }
          }.to_json)
        end
      end

      context 'and the password is valid' do
        let(:params) do
          {
            user_email: user.email,
            password: password
          }
        end

        it 'returns bad request' do
          perform

          expect(response.status).to eq(201)
        end

        it 'returns the access_token' do
          perform
          access_token = JSON.parse(response.body)['data']['access_token']

          expect(access_token).not_to be_nil
        end
      end
    end
  end

end
