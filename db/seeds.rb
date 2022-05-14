room1 = Room.create(name: 'Sala 1')
room2 = Room.create(name: 'Sala 2')
room3 = Room.create(name: 'Sala 3')
room4 = Room.create(name: 'Sala 4')
user1 = User.create(name: 'Italo', email: 'italo@getninjas.com.br', password: '123456')
user2 = User.create(name: 'Mariana', email: 'mariana@getninjas.com.br', password: '123456')
user3 = User.create(name: 'Aurora', email: 'aurora@getninjas.com.br', password: '123456')
start_time = DateTime.now - 15.minutes
end_time = DateTime.now + 15.minutes

Meeting.create(
  start_time: start_time,
  end_time: end_time,
  user_id: user1.id,
  room: room1,
  users: [user2, user3]
)
