defmodule Agenda.ScheduleTest do
  use ExUnit.Case

  alias Agenda.Schedule

  describe "list_schedule/0" do
    test "when list created schedules" do
      Schedule.list_schedule()

      assert [%{}]
    end
  end

  describe "insert_schedule/1" do
    test "insert schedule struct in data base" do
      schedule_struct = %Agenda.Schedule.Scheduler{
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

      Schedule.insert_schedule(schedule_struct)

      assert %Agenda.Schedule.Scheduler{
        date: %{"day" => 3, "month" => 12, "year" => 2021},
        id: 5,
        inserted_at: ~N[2021-11-29 20:49:23],
        rooms_id: 2,
        time: %{
          "end" => %{"hours" => "17", "minutes" => "20"},
          "start" => %{"hours" => "15", "minutes" => "30"}
        },
        title: "testeeeee",
        updated_at: ~N[2021-11-29 20:49:23]
      }
    end
  end

  describe "get_schedule/1" do
    test "finds the given title on the data base" do
      title = "testeee"

      Schedule.get_schedule(title)

      assert {:ok, %Agenda.Schedule.Scheduler{
        date: %{"day" => 3, "month" => 12, "year" => 2021},
        id: 2,
        inserted_at: ~N[2021-11-29 20:02:56],
        rooms_id: 2,
        time: %{
          "end" => %{"hours" => "17", "minutes" => "20"},
          "start" => %{"hours" => "15", "minutes" => "30"}
        },
        title: "testee",
        updated_at: ~N[2021-11-29 20:02:56]
      }}
    end

    test "when data base doesn't find the given title" do
      title = "test_value_to_return_nil"

      Schedule.get_schedule(title)

      assert {:error}
    end
  end
end
