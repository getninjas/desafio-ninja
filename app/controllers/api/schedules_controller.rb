module Api
  class SchedulesController < ApplicationController
    deserializable_resource :schedule, only: %i[create update]
    before_action :authenticate_api_user!

    def index
      CRUDManagement::Index.perform(
        paginate_params.merge(ransack_params: ransack_options),
        index_with_pagination_callback,
        Schedule
      )
    end

    def show
      CRUDManagement::Show.perform(
        find_params,
        default_show_callbacks,
        Schedule
      )
    end

    def create
      ScheduleManagement::Create.perform(
        schedule_params.merge(room_id: room_id, user_id: current_api_user.id),
        default_create_callbacks,
        Schedule
      )
    end

    def update
      CRUDManagement::Update.perform(
        find_params,
        schedule_params,
        default_update_callbacks,
        Schedule.where(user_id: current_api_user.id)
      )
    end

    def destroy
      CRUDManagement::Destroy.perform(
        find_params,
        default_destroy_callbacks,
        Schedule.where(user_id: current_api_user.id)
      )
    end

    private

    def schedule_params
      params.require(:schedule).permit(:id, :start_time, :end_time)
    end

    def room_id
      params.require(:room_id)
    end

    def find_params
      { id: params.require(:id)}
    end
  end
end