# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create Rooms
if Room.last.nil?
  p 'Create Room 1'
  Room.create(name: 'Room1')
  p 'Create Room 2'
  Room.create(name: 'Room2')
  p 'Create Room 3'
  Room.create(name: 'Room3')
  p 'Create Room 4'
  Room.create(name: 'Room4')
end
