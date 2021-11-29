defmodule Agenda.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Agenda.Repo,
      # Start the Telemetry supervisor
      AgendaWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Agenda.PubSub},
      # Start the Endpoint (http/https)
      AgendaWeb.Endpoint
      # Start a worker by calling: Agenda.Worker.start_link(arg)
      # {Agenda.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Agenda.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AgendaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
