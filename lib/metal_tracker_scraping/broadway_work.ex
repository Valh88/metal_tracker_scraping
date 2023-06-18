defmodule MetalTrackerScraping.BroadwayWork do
  alias MetalTrackerScraping.ScraperProducer
  alias MetalTrackerScraping.BroadwayWork
  alias MetalTrackerScraping.Core.AlbumTracker
  use Broadway
  require Logger

@options [
            name: BroadwayWork,
            producer: [
              module: {ScraperProducer, []},
              transformer: {BroadwayWork, :transform, []}
            ],
            processors: [
              default: [max_demand: 8, concurrency: 8]
            ],
            batchers: [
              default: [batch_size: 8, concurrency: 1]
            ]
         ]

    def start_link(_args) do
    Broadway.start_link(__MODULE__, @options)
  end

  def transform(event, _options) do
    %Broadway.Message{
      data: event,
      acknowledger: {BroadwayWork, :urls , []}
    }
  end

  def ack( :urls , _successful, _failed) do
    :ok
  end

  def handle_message(_processor, message, _context) do
    #IO.inspect(message)
    AlbumTracker.start(message.data)
    Broadway.Message.put_batch_key(message, message.data)

    #Broadway.Message.failed(message, "offline")

  end

  def handle_batch(_batcher, [url], _batch_info, _context) do
    #Logger.info( " Batch Processor received  #{ message.data } " )
    #data = AlbumTracker.start(url.data)
    IO.inspect(inspect([url]))
    # IO.puts("312312")
    [url]
  end
end
