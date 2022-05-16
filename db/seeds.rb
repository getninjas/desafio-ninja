# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

['Sala 1', 'Sala 2', 'Sala 3', 'Sala 4'].each do |name_meeting_room|
  MeetingRoom.create(name: name_meeting_room)
end
