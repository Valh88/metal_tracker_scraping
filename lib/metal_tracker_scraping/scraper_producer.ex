defmodule MetalTrackerScraping.ScraperProducer do
  use GenStage
  require Logger

  def start_link(_args) do
    initial_state = []
    GenStage.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  def init(initial_state) do
    Logger.info("start producer")
    {:producer, initial_state}
  end

  def handle_demand(demand, state) do
    Logger.info(inspect(demand))
    events = []
    {:noreply, events, state}
  end

  def parse_page(list_of_pages) when is_list(list_of_pages) do
    MetalTrackerScraping.BroadwayWork
    |> Broadway.producer_names()
    |> List.first()
    |> GenStage.cast({ :urls , list_of_pages})
  end

  def handle_cast({:urls, list_of_pages}, state) do
    {:noreply, list_of_pages, state}
  end
end
