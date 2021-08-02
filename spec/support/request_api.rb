module RequestAPI
  def body_json
    json = JSON.parse(response.body)
  rescue
    return {}
  end
end

RSpec.configure do |config|
  config.include RequestAPI, type: :request
end
