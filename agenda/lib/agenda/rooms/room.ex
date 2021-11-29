defmodule Agenda.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  alias Agenda.Schedule.Scheduler

  schema "rooms" do
    field :title, :string
    has_many :scheduler, Scheduler

    timestamps()
  end

  @doc false
  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
