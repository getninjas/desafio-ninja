module ApiCommonResponses
  extend ActiveSupport::Concern

  def render_success(data = {})
    render json: data, status: :ok
  end

  def render_created(data = {})
    render json: data, status: :created
  end

  def render_unprocessable_entity(resource = nil)
    render json: { errors: resource }, status: :unprocessable_entity
  end

end
