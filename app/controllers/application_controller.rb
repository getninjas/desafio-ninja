class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include Pagination::Schema
  include CommonApiOptions
end
