namespace :dev do
  desc "TODO"
  task setup: :environment do

    Room.all.destroy
    Scheduling.all.destroy

    4.times do |i|
      room = Room.create!
      5.times do |j|
        room.days.create!({
          week_day: j,
          time_from: Time.parse("09:00"),
          time_to: Time.parse("18:00"),
        })
      end
    end

    #room = Room.first
    #Scheduling.create!({ :date => "2022-01-01", :time => "09:00" }.merge({:room_id => room.id}))
  end

end
