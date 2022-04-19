# frozen_string_literal: true

module Pagination
  module Schema

    def pagination_links(collection)
      current_uri = request.env['PATH_INFO']
      meta_links = {}

      pages(collection).each do |key, value|
        query_params = request.query_parameters.merge(page: value)
        meta_links[key] = "#{current_uri}?#{query_params.to_param}"
      end

      meta_links
    end

    def pages(collection)
      {}.tap do |paging|
        paging[:self] = collection.current_page
        paging[:first] = 1
        paging[:last] = collection.total_pages if collection.total_pages.positive?

        # paging[:prev] = collection.current_page - 1 unless collection.current_page == 1
        # paging[:next] = collection.current_page + 1 unless collection.current_page >= collection.total_pages
        paging[:prev] = collection.prev_page unless collection.current_page == 1
        paging[:next] = collection.next_page unless collection.current_page >= collection.total_pages
      end
    end

    def paginate_collection(collection, options = {})
      options[:page] = params[:page] || 1
      options[:per_page] = options.delete(:per_page) || params[:per_page]

      collection.paginate(options)
    end

    def meta(collection)
      {
        pagination:
          {
            total_pages: collection.total_pages,
            total_objects: collection.total_count
          }
      }
    end
  end
end