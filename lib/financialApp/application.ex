defmodule FinancialApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      FinancialApp.Repo,
      # Start the Telemetry supervisor
      FinancialAppWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: FinancialApp.PubSub},
      # Start the Endpoint (http/https)
      FinancialAppWeb.Endpoint
      # Start a worker by calling: FinancialApp.Worker.start_link(arg)
      # {FinancialApp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FinancialApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FinancialAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
