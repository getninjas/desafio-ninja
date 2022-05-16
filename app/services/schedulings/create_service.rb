class Schedulings::CreateService < BusinessProcess::Base
  needs :scheduling_params

  steps :find_meeting_room,
        :create

  def call
    process_steps

    @scheduling
  end

  private

  def find_meeting_room
    @meeting_room = MeetingRoom.find_by(id: scheduling_params[:meeting_room_id])

    fail(I18n.t('services.meeting_room.errors.not_found')) unless @meeting_room.present?
  end

  def create
    @scheduling = Scheduling.new(scheduling_params.except(:meeting_room))

    @scheduling.assign_attributes(meeting_room: @meeting_room)

    fail(@scheduling.errors.full_messages) unless @scheduling.save
  end

end
