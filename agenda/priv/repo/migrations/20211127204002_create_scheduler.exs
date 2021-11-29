defmodule Agenda.Repo.Migrations.CreateScheduler do
  use Ecto.Migration

  def change do
    create table(:scheduler) do
      add :title, :string
      add :date, :map
      add :time, :map
      add :rooms_id, references(:rooms)

      timestamps()
    end
  end
end
