defmodule MetalTrackerScraping.Core.MetalTracker do
  require Logger

  @base_url "https://www.discogs.com"

  def get_url([page: page, style_exact: style_exact]) do
    {:ok, @base_url <> "/ru/search/?ev=em_rs" <> "&style_exact=#{style_exact}" <> "&layout=sm" <> "&page=#{page}"}
  end

  def get_url(_) do
    {:error, IO.inspect([page: "номер страницы", style_exact: "стиль музыки"])}
  end

  def get_page({:ok, url}) do
    case HTTPoison.get(url) do
      {:ok, html} -> {:ok, html.body}
      {:error, er} -> Logger.error(inspect("#{er} | #{url}"))
    end
  end

  def scraping({:ok, body}) do
    {:ok, data} = Floki.parse_document(body)
    try do
      data
      |> Floki.find("ul li div h4 a.search_result_title")
      |> Floki.attribute("href")
      |> Enum.map(fn url -> @base_url <> url end)
    rescue
      e -> Logger.error(e)
    end
  end

  def start(ops) do
    ops
    |> get_url()
    |> get_page()
    |> scraping()
  end
end
