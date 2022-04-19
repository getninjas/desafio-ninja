require 'rails_helper'

RSpec.describe 'Create User', type: :request do
  context 'Doing a valid user' do
    it 'Creating user' do
      new_user = attributes_for(:user).merge(password_confirmation: "12345678")

      post '/api/users', params: { user: new_user }

      attributes = json_body[:data][:attributes]

      expect(response).to have_http_status 201
      expect(response).not_to have_http_status 422
      expect(response).not_to have_http_status 401
      expect(attributes[:name]).to eq new_user[:name]
      expect(attributes[:email]).to eq new_user[:email]
    end
  end

  context 'Doing a invalid user' do
    it 'Creating user without email' do
      new_user = build(:user)
      new_user.password = '12345678'
      new_user.password_confirmation = '12345678'

      user_params = {
        name: new_user.name,
        password: new_user.password,
        password_confirmation: new_user.password_confirmation
      }
      post '/api/users', params: { user: user_params }

      errors = json_body[:errors].first
      expect(response).to have_http_status 422
      expect(errors[:detail]).to eq "E-mail não pode ficar em branco"
      expect(errors[:title]).to eq "E-mail inválido(a)"
    end

    it 'Creating user without name' do
      new_user = build(:user)
      new_user.password = '12345678'
      new_user.password_confirmation = '12345678'

      user_params = {
        email: new_user.email,
        password: new_user.password,
        password_confirmation: new_user.password_confirmation
      }

      post '/api/users', params: { user: user_params }

      errors = json_body[:errors].first
      expect(response).to have_http_status 422
      expect(errors[:detail]).to eq "Nome não pode ficar em branco"
      expect(errors[:title]).to eq "Nome inválido(a)"
    end

    it 'Creating user with different password ' do
      new_user = build(:user)
      new_user.password = '12345678'
      new_user.password_confirmation = '12345678'

      user_params = {
        name: new_user.name,
        email: new_user.email,
        password: '12345678',
        password_confirmation: '1234567'
      }
      post '/api/users', params: { user: user_params }

      errors = json_body[:errors].first
      expect(response).to have_http_status 422
      expect(errors[:detail]).to eq "Senha de confirmação é diferente da senha"
      expect(errors[:title]).to eq "Senha de confirmação inválido(a)"
    end

    it 'Creating user without password' do
      new_user = build(:user)
      new_user.password = '12345678'
      new_user.password_confirmation = '12345678'

      user_params = {
        name: new_user.name,
        email: new_user.email
      }
      post '/api/users', params: { user: user_params }

      errors = json_body[:errors].first
      expect(response).to have_http_status 422
      expect(errors[:title]).to eq ("Senha inválido(a)")
      expect(errors[:detail]).to eq ("Senha não pode ficar em branco")
    end

    it 'Creating user without password confirmation' do
      new_user = build(:user)
      new_user.password = '12345678'
      new_user.password_confirmation = '12345678'

      user_params = {
        name: new_user.name,
        email: new_user.email,
        password: new_user.password,
      }
      post '/api/users', params: { user: user_params }

      errors = json_body[:errors].first
      expect(response).to have_http_status 422
      expect(errors[:title]).to eq ("Senha de confirmação inválido(a)")
      expect(errors[:detail]).to eq ("Senha de confirmação não pode ficar em branco")
    end
  end
end
