module Api
  module V1
    class MeetingController < Api::V1::ApiController
      before_action :find_meeting, only: %i[show update destroy]
      before_action :check_my_meetings, only: %i[show]
      before_action :check_my_created_meetings, only: %i[update destroy]

      def my_created_meetings
        @my_created_meetings = current_api_user.created_meetings

        if @my_created_meetings.present?
          render :my_created_meetings, status: :ok
        else
          render json: { message: "You don't have created meetings yet." }, status: :ok
        end
      end

      def my_meetings_invitations
        @my_meetings_invitations = current_api_user.meetings

        if @my_meetings_invitations.present?
          render :my_meetings_invitations, status: :ok
        else
          render json: { message: "You don't have any inveted meetings yet." }, status: :ok
        end
      end

      def create
        (respond_contract_errors; return) if meeting_contract.errors.present?
        (respond_no_room_available; return) if available_rooms.blank?

        @meeting_cadidate = Meeting.new(
          start_time: formatted_params[:start_time],
          end_time: formatted_params[:end_time],
          user_id: current_api_user.id,
          room_id: available_rooms,
          subject: formatted_params[:subject]
        )
        @meeting_cadidate.users << find_guests if find_guests.present?

        if @meeting_cadidate.save
          render :created_meeting, status: :ok
        else
          render json: { errors: @meeting_cadidate.errors.messages }, status: :unprocessable_entity
        end
      end

      def update
        @meeting.subject = formatted_params[:subject] if formatted_params[:subject].present?
        if formatted_params[:users_emails].present?
          @meeting_cadidate.users << find_guests if find_guests.present?
        end
        if formatted_params[:start_time].present? && formatted_params[:end_time].present? &&
          @meeting.start_time != formatted_params[:start_time] &&
          @meeting.end_time != formatted_params[:end_time]

          (respond_no_room_available; return) if available_rooms.blank?
          @meeting.room_id = available_rooms
          @meeting.start_time = formatted_params[:start_time]
          @meeting.end_time = formatted_params[:end_time]
        end

        if @meeting.save
          render :updated_meeting, status: :ok
        else
          render json: { errors: @meeting.errors.messages }, status: :unprocessable_entity
        end
      end

      def show; end

      def destroy
        render json: '', status: :ok if @meeting.destroy
      end

      private

      def permitted_params
        params.require(:meeting).permit(
          :start_time,
          :end_time,
          :subject
        )
      end

      def formatted_params
        formatted_params = permitted_params
        formatted_params.merge!(users_emails: params[:users_emails]) if params[:users_emails].present?
        formatted_params.to_h
      end

      def find_meeting
        @meeting = Meeting.find(params[:id])
      end

      def check_my_meetings
        unless current_api_user.meetings.include?(@meeting) ||
          current_api_user.created_meetings.include?(@meeting)
          render json: { message: 'You have to belong to this meeting to do this action.' },
                status: :forbidden
          return
        end
      end

      def check_my_created_meetings
        unless current_api_user.created_meetings.include?(@meeting)
          render json: { message: 'You have to own this meeting to do this action.' },
                status: :forbidden
          return
        end
      end

      def meeting_contract
        @meeting_contract ||= MeetingContract.new.call(formatted_params)
      end

      def respond_contract_errors
        render json: { errors: meeting_contract.errors.messages.map(&:to_h) },
              status: :bad_request
      end

      def respond_no_room_available
        render json: { message: 'No room available for this time.'}, status: :ok
      end

      def find_guests
        return nil if formatted_params[:users_emails].blank?
        guests = formatted_params[:users_emails].map { |email| User.find_by(email: email) }
        guests.compact!
        guests
      end

      def available_rooms
        @available_rooms ||= FindRoomService.new(
          formatted_params[:start_time].to_datetime,
          formatted_params[:end_time].to_datetime
        ).find
      end
    end
  end
end
