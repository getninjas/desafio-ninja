namespace :sample_data do
  desc 'create deafult rooms'
  task rooms: :environment do
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
  end
end