class ApiController < ActionController::API
  include ApiCommonResponses

  wrap_parameters false
end
