defmodule Agenda.Schedule.CreateSchedule do
  alias Agenda.Schedule.Scheduler

  def create(schedule_params) do
    case validate(schedule_params) do
      {:ok, schedule_params} ->
        schedule =
          schedule_params
          |> Enum.map(fn param ->
            Scheduler.changeset(%Scheduler{}, param)
          end)
          |> hd()
          |> Scheduler.applied_changeset()

        {:ok, schedule}

      {:error, message} ->
        {:error, message}
    end
  end

  defp validate(schedule_params) do
    case Enum.map(schedule_params, fn param -> param["date"] end) do
      [nil] ->
        {:error, "Você deve informar uma data!"}

      _ ->
        schedule_params
        |> validate_room()
        |> validate_week()
        |> validate_time()
    end
  end

  defp validate_time({:error, message}), do: {:error, message}

  defp validate_time({:ok, schedule_params}) do
    schedule =
      schedule_params
      |> hd()

    with {start_hour, _} <- Integer.parse(schedule["time"]["start"]["hours"]),
         true <- start_hour >= 9,
         true <- start_hour < 18,
         {end_hour, _} <- Integer.parse(schedule["time"]["end"]["hours"]),
         true <- end_hour >= 9,
         true <- start_hour <= end_hour,
         {end_minutes, _} <- Integer.parse(schedule["time"]["end"]["minutes"]),
         {start_minutes, _} <- Integer.parse(schedule["time"]["start"]["minutes"]),
         true <- check_time(start_hour, end_hour, start_minutes, end_minutes),
         true <- end_hour <= 18 do
      {:ok, schedule_params}
    else
      false -> {:error, "Apenas é possível agendar em horário comercial"}
    end
  end

  defp check_time(start_hour, end_hour, start_minutes, end_minutes) do
    case start_hour == end_hour do
      true ->
        case end_minutes > start_minutes do
          true ->
            case end_hour == 18 and end_minutes == 0 do
              true ->
                true

              false ->
                true
            end

          false ->
            false
        end

      false ->
        true
    end
  end

  defp validate_room(schedule_params) do
    schedule =
      schedule_params
      |> hd()

    case schedule["rooms_id"] < 1 || schedule["rooms_id"] > 4 do
      true ->
        {:error, "insira uma sala válida"}

      false ->
        {:ok, schedule_params}
    end
  end

  defp validate_week({:error, message}), do: {:error, message}

  defp validate_week({:ok, schedule_params}) do
    day_of_week =
      schedule_params
      |> Enum.map(fn param -> param["date"] end)
      |> hd()
      |> Enum.map(fn {_key, value} -> value end)
      |> Enum.reverse()
      |> List.to_tuple()
      |> Calendar.Date.day_of_week_name()

    case day_of_week === "Saturday" || day_of_week === "Sunday" do
      true ->
        {:error, "Não é possível agendar em finais de semana"}

      false ->
        {:ok, schedule_params}
    end
  end
end
