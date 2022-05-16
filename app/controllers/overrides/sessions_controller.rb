# frozen_string_literal: true

module Overrides
  class SessionsController < DeviseTokenAuth::SessionsController
    skip_before_action :authenticate_api_user!, :raise => false
  end
end
