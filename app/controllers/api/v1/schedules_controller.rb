module Api
  module V1
    class SchedulesController < ApplicationController
      before_action :set_room, only: [:index, :show, :create, :update, :destroy]
      before_action :set_schedule, only: [:show, :update, :destroy]

      def index
        @schedules = @room.schedules.order(:start_at)
      end

      def show; end

      def create
        @schedule = @room.schedules.new
        schedule_save!
      end

      def update
        schedule_save!
      end

      def destroy
        @schedule.destroy!
      end

      private

      def schedule_params
        return {} unless params.has_key?(:schedule)
        params.require(:schedule).permit(:scheduled_by, :start_at, :end_at)
      end

      def set_room
        @room = Room.find(params[:room_id])
      rescue
        head :not_found
      end

      def set_schedule
        @schedule = @room.schedules.find(params[:id])
      rescue
        head :not_found
      end

      def build_schedule(attributes)
        @schedule.attributes = attributes
      end

      def schedule_save!
        build_schedule(schedule_params)
        @schedule.save!
        render :show
      rescue
        render json: { message: @schedule.errors.messages }, status: :unprocessable_entity
      end
    end
  end
end
