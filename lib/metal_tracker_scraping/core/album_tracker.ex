defmodule MetalTrackerScraping.Core.AlbumTracker do
  require Logger
  alias MetalTrackerScraping.Core.AlbumTracker
  @path "data"

  defstruct [
    :name,
    :info,
    tracks: []
  ]

  def get_page_album(url) do
    case HTTPoison.get(url) do
      {:ok, html} -> {:ok, html.body}
      {:error, error} -> Logger.info(error)
    end
  end

  def scraping({:ok, body}) do
    album = %AlbumTracker{}

    {:ok, data} = Floki.parse_document(body)
    album =
    Floki.find(data, "div.content_3oPo5 div h1")
    |> Floki.text()
    |> update_name(album)

    album =
    Floki.find(data, "table.table_1fWaB tr")
    |> Floki.text()
    |> update_info(album)

    Floki.find(data, "table.tracklist_3QGRS tr")
    |> Floki.find("td.trackTitle_CTKp4 span.trackTitle_CTKp4")
    |> Floki.text(sep: "|")
    |> String.split("|")
    |> Enum.with_index(fn element, index  -> {index + 1, element} end)
    |> update_tracks(album)
  end

  def write_in_file(%AlbumTracker{} = album) do
    f = File.open!("#{@path}/data.csv", [:append, :utf8])
    IO.write(f, CSVLixir.write_row([album.name, album.info, inspect(album.tracks)]))
    File.close(f)
  end

  def start(url) do
    url
    |> get_page_album()
    |> scraping()
    |> write_in_file()
  end

  defp update_name(name, album), do: %{album | name: name}
  defp update_info(info, album), do: %{album | info: info}
  defp update_tracks(traks, album), do: %{album | tracks: traks}
end
