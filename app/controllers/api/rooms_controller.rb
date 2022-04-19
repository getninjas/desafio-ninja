module Api
  class RoomsController < ApplicationController
    before_action :authenticate_api_user!, only: %i[index show]

    def index
      CRUDManagement::Index.perform(
        paginate_params.merge(ransack_params: ransack_options),
        index_with_pagination_callback,
        Room
      )
    end

    def show
      CRUDManagement::Show.perform(
        find_params,
        default_show_callbacks,
        Room
      )
    end

    private

    def find_params
      { id: params.require(:id)}
    end
  end
end