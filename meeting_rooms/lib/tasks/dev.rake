namespace :dev do
  desc 'TODO'
  task setup: :environment do
    Room.all.destroy
    Scheduling.all.destroy

    4.times do
      room = Room.create!
      5.times do
        room.days.create!({ week_day: j, time_from: Time.parse('09:00'), time_to: Time.parse('18:00') })
      end
    end
  end
end
