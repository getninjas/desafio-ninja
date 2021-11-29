# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Agenda.Repo.insert!(%Agenda.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
Agenda.Room.create_rooms(%{title: "Sala 01"})
Agenda.Room.create_rooms(%{title: "Sala 02"})
Agenda.Room.create_rooms(%{title: "Sala 03"})
Agenda.Room.create_rooms(%{title: "Sala 04"})
