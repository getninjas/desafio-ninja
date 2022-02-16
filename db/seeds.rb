# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

sala_azul = Room.create(
  name: 'Sala azul',
  open_at: 9,
  close_at: 18,
  people_limit_by_meeting: 10,
  time_limit_by_meeting: 60
)
sala_amarela = Room.create(
  name: 'Sala amarela',
  open_at: 9,
  close_at: 18,
  people_limit_by_meeting: 10,
  time_limit_by_meeting: 60
)
sala_preta = Room.create(
  name: 'Sala preta',
  open_at: 9,
  close_at: 18,
  people_limit_by_meeting: 10,
  time_limit_by_meeting: 60
)
sala_verde = Room.create(
  name: 'Sala verde',
  open_at: 9,
  close_at: 18,
  people_limit_by_meeting: 5,
  time_limit_by_meeting: 60
)

employee_junior = Employee.create(name: 'Junior', department: 'Engineering')
employee_fernando = Employee.create(name: 'Fernando', department: 'Engineering')
employee_lucas = Employee.create(name: 'Lucas', department: 'Engineering')
employee_matheus = Employee.create(name: 'Matheus', department: 'Engineering')
employee_victor = Employee.create(name: 'Victor', department: 'Engineering')

scheduled_sala_verde = Scheduler.create(meeting_description: 'Semanal', start_meeting_time: DateTime.now, end_meeting_time: DateTime.now + 30.minutes, room: sala_verde)
scheduled_sala_azul = Scheduler.create(meeting_description: 'Sprint', start_meeting_time: DateTime.now, end_meeting_time: DateTime.now + 40.minutes, room: sala_azul)

scheduled_sala_verde.employees << employee_matheus
scheduled_sala_verde.employees << employee_victor


scheduled_sala_azul.employees << employee_matheus
scheduled_sala_azul.employees << employee_victor