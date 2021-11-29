defmodule Agenda.Repo do
  use Ecto.Repo,
    otp_app: :agenda,
    adapter: Ecto.Adapters.Postgres
end
