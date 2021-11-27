# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Rooms', type: :request do
  describe 'GET /index' do
    before(:all) do
      create_list(:room, 2)
    end

    it 'show all rooms' do
      get '/rooms'
      expect(response).to have_http_status(:ok)
    end
  end
end
