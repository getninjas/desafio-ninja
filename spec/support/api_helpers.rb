module ApiHelpers
  def json_body
    JSON.parse(response.body).deep_symbolize_keys
  end

  def body_attr
    json_body[:data][:attributes]
  end
end
