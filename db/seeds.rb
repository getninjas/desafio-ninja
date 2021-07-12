# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Get the default values of collumns
room_attributes = Room.new.attributes

records = []
4.times do |i|
  room = room_attributes.dup

  room[:id] = i + 1
  room[:name] = "room #{i + 1}"
  room[:created_at] = Time.current
  room[:updated_at] = room[:created_at]
  records << room
end

Room.insert_all(records)
