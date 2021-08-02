p "Creating rooms..."
["Blue Room", "Yellow Room Two", "Red Room", "Green Room"].each do |room|
  Room.create(name: room)
end
p "Done."
