defmodule MetalTrackerScraping.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
alias MetalTrackerScraping.ScraperProducer
  alias MetalTrackerScraping.BroadwayWork
  use Application

  @impl true
  def start(_type, _args) do
    IO.inspect("MetalTrackerScraping.start_parsing  51, [page: <страница>, style_exact: <стиль>]")
    children = [
      # Starts a worker by calling: MetalTrackerScraping.Worker.start_link(arg)
      # {MetalTrackerScraping.Worker, arg}
      BroadwayWork,
      ScraperProducer
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MetalTrackerScraping.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
