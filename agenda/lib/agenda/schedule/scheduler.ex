defmodule Agenda.Schedule.Scheduler do
  use Ecto.Schema
  import Ecto.Changeset

  alias Agenda.Rooms.Room

  @fields_to_export ~w(title rooms_id date time)a
  @derive {Jason.Encoder, only: @fields_to_export}

  @required_params [:title, :date, :time, :rooms_id]

  schema "scheduler" do
    field :title, :string
    field :date, :map
    field :time, :map
    belongs_to :rooms, Room

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = schedule, attrs) do
    schedule
    |> cast(attrs, @required_params)
    |> validate_required(@required_params)
    |> validate_length(:title,
      max: 160,
      message: "O tamanho máximo é de 160 caracteres"
    )
  end

  def applied_changeset(changeset) do
    apply_changes(changeset)
  end
end
