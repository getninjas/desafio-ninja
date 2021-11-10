class SendEmailToGuestsWorker
  include Sidekiq::Worker

  def perform(schedule_id)
    Schedule
      .includes(:guests)
      .where(id: schedule_id)
      .each do |schedule|
        schedule.guests.each do |guest|
          GuestMailer.send_email(guest.email).deliver_now
        end
      end
  end
end
