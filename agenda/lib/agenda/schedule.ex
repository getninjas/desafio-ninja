defmodule Agenda.Schedule do
  alias Agenda.Repo
  alias Agenda.Schedule.Scheduler

  def insert_schedule(schedule_struct) do
    schedule_struct
    |> Repo.insert()
  end

  def list_schedule do
    Repo.all(Scheduler)
  end

  def get_schedule(title) do
    case Repo.get_by(Scheduler, title: title) do
      nil ->
        {:error}

      schedule ->
        {:ok, schedule}
    end
  end

  def delete_schedule(%Scheduler{} = schedule) do
    Repo.delete(schedule)
  end

  def update_schedule(%Scheduler{} = schedule, attrs) do
    schedule
    |> Scheduler.changeset(%{title: attrs})
    |> Repo.update()
  end
end
