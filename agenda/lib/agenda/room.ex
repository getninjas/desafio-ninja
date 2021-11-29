defmodule Agenda.Room do
  alias Agenda.Rooms.Room
  alias Agenda.Repo

  def create_rooms(attrs \\ %{}) do
    attrs
    |> Room.changeset()
    |> Repo.insert()
  end

  def list_rooms do
    Repo.all(Room)
  end
end
