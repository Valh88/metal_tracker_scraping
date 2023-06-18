defmodule MetalTrackerScraping do
  alias MetalTrackerScraping.Core.MetalTracker
  alias MetalTrackerScraping.ScraperProducer
  require Logger

  @moduledoc """
  Documentation for `MetalTrackerScraping`.
  """

  def start_parsing(num_element \\ 400_000, ops) do
    [page: page, style_exact: style_exact] = ops
    Logger.info([page: page, style_exact: style_exact])
    #urls = MetalTracker.start(ops)
    #MetalTrackerScraping.get_url_band 51, [page: 1, style_exact: "Black+Metal"]
    ScraperProducer.parse_page(MetalTracker.start(ops))

    Process.sleep(5)

    if  page * 50 >= num_element do
      stop(page * 50)
    else
      start_parsing(num_element, [page: page + 1, style_exact: style_exact])
    end
  end

  defp stop(pages), do: Logger.info("Страницы взяты #{pages}")
end
