titles = ['QG Ninja 1', 'QG Ninja 2', 'QG Ninja 3', 'QG Ninja 4']

titles.each do |title|
  Room.create(name: title)
end