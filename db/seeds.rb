1.upto(4) do |room_number|
  Room.create(name: "Room##{ room_number }")
end

User.create(email: 'sullyvan@email.com')
