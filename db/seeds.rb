puts "Starting seed process..."
titles = ['QG Ninja 1', 'QG Ninja 2', 'QG Ninja 3', 'QG Ninja 4']

titles.each do |title|
  room = Room.create(name: title)
  starts_at = DateTime.new(2021, 11, 26, 10, 0, 0)
  ends_at = DateTime.new(2021, 11, 26, 11, 0, 0)
  rand_time = rand(30..90).minutes

  Meeting.create(title: 'Comunicado Importante', starts_at: starts_at + rand_time, ends_at: ends_at + rand_time, room: room)
end

puts "Finished seed process!"
