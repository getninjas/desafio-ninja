# frozen_string_literal: true

module CommonApiOptions
  def default_create_callbacks
    success_callback = lambda do |caller|
      render jsonapi: caller, status: :created
    end

    {success: success_callback, error: error_callback_default}
  end

  def default_index_callbacks
    {success: success_callback_default}
  end

  def index_with_pagination_callback
    {success: index_callback_whit_page_links}
  end

  def default_show_callbacks
    {success: success_callback_default, error: error_callback_default}
  end

  def default_destroy_callbacks
    {success: success_callback_default, error: error_callback_default}
  end

  def default_update_callbacks
    {success: success_callback_default, error: error_callback_default}
  end

  private

  def success_callback_default
    lambda do |caller|
      render jsonapi: caller, status: :ok, include: include_options, fields: fields_options
    end
  end

  def index_callback_whit_page_links
    lambda do |caller|
      render jsonapi: caller, include: include_options, links: pagination_links(caller),
             meta: meta(caller), status: :ok, fields: fields_options
    end
  end

  def error_callback_default
    lambda do |caller|
      render jsonapi_errors: caller.errors, status: :unprocessable_entity
    end
  end

  def include_options
    params.slice(:include).as_json.deep_symbolize_keys[:include]
  end

  def fields_options
    options = params.permit(fields: {}).as_json.deep_symbolize_keys[:fields]
    return {} if options.blank?

    options.transform_values { |v| v.split(',').collect { |e| e.strip.to_sym } }
  end

  def search_params
    params.permit(q: {})
  end

  def sort_options
    sort_params = params.permit(:sort)
    sort_params.transform_keys { |_k| :s }
  end

  def ransack_options
    (search_params[:q] || {}).merge(sort_options)
  end

  def paginate_params
    params.permit(:page, :per_page)
  end
end
