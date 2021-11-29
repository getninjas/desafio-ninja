defmodule AgendaWeb.SchedulerController do
  use AgendaWeb, :controller

  alias Agenda.Schedule
  alias Agenda.Schedule.CreateSchedule
  alias AgendaWeb.FallbackController

  def create(conn, params) do
    with false <- params == %{},
         {:ok, schedule} <- CreateSchedule.create(params["schedule"]) do
      Schedule.insert_schedule(schedule)

      conn
      |> put_status(:created)
      |> json(schedule)
    else
      {:error, message} -> FallbackController.call(conn, {:error, message})
      true -> FallbackController.call(conn, {:error, "insira os dados!"})
    end
  end

  def show(conn, _params) do
    schedules_list =
      Schedule.list_schedule()
      |> Enum.sort_by(&{&1.rooms_id})

    conn
    |> json(schedules_list)
  end

  def update(conn, %{"schedule_title" => title, "title" => title_params}) do
    with {:ok, schedule} <- Schedule.get_schedule(title) do
      Schedule.update_schedule(schedule, title_params)

      conn
      |> put_status(:ok)
      |> json("Alterado com sucesso")
    else
      _ ->
        FallbackController.call(conn, {:error, "Erro ao alterar título da agenda ou já alterada"})
    end
  end

  def delete(conn, %{"schedule_title" => title}) do
    with {:ok, schedule} <- Schedule.get_schedule(title) do
      Schedule.delete_schedule(schedule)

      conn
      |> put_status(:ok)
      |> json("Deletado com sucesso")
    else
      _ -> FallbackController.call(conn, {:error, "Erro ao deletar agenda ou já deletada"})
    end
  end
end
