# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#Criação da sede São Paulo
organization = Organization.create(name: "GetNinjas São Paulo", adress: "São Paulo-SP", number_of_rooms: 4, work_on_weekend: false, business_hours_start: "09:00", business_hours_end: "18:00")

4.times do |room|
  Room.create(name: "Sala #{room + 1}", organization_id: organization.id )
end