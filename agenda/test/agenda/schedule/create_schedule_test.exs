defmodule Agenda.Schedule.CreateScheduleTest do
  use ExUnit.Case, async: true

  alias Agenda.Schedule.CreateSchedule

  describe "create/1" do
    test "when date params is missing" do
      schedule_params = [
        %{
          "rooms_id" => 2,
          "time" => %{
            "end" => %{"hours" => "17", "minutes" => "20"},
            "start" => %{"hours" => "15", "minutes" => "30"}
          },
          "title" => "teste"
        }
      ]

      CreateSchedule.create(schedule_params)

      assert {:error, "você deve informar uma data!"}
    end

    test "when all params are correct" do
      schedule_params = [
        %{
          "date" => %{"day" => 3, "month" => 12, "year" => 2021},
          "rooms_id" => 2,
          "time" => %{
            "end" => %{"hours" => "17", "minutes" => "20"},
            "start" => %{"hours" => "15", "minutes" => "30"}
          },
          "title" => "testeee"
        }
      ]

      CreateSchedule.create(schedule_params)

      assert {:ok, %Agenda.Schedule.Scheduler{
        date: %{"day" => 3, "month" => 12, "year" => 2021},
        id: nil,
        inserted_at: nil,
        rooms_id: 2,
        time: %{
          "end" => %{"hours" => "17", "minutes" => "20"},
          "start" => %{"hours" => "15", "minutes" => "30"}
        },
        title: "testeee",
        updated_at: nil
        }
      }
    end
  end
end
