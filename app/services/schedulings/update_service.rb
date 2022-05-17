class Schedulings::UpdateService < BusinessProcess::Base
  needs :scheduling_params
  needs :scheduling

  steps :find_meeting_room,
        :create

  def call
    process_steps

    scheduling
  end

  private

  def find_meeting_room
    meeting_room = MeetingRoom.find_by(id: scheduling_params[:meeting_room_id])

    fail(I18n.t('services.meeting_room.errors.not_found')) unless meeting_room.present?
  end

  def create
    scheduling.update(scheduling_params)

    fail(scheduling.errors.full_messages) if scheduling.errors.present?
  end

end
