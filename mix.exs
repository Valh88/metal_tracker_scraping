defmodule MetalTrackerScraping.MixProject do
  use Mix.Project

  def project do
    [
      app: :metal_tracker_scraping,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {MetalTrackerScraping.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    {:httpoison, "~> 2.1.0"},
    {:floki, "~> 0.34.3"},
    {:gen_stage, "~> 1.2.1"},
    {:broadway, "~> 1.0.7"},
    {:csvlixir, "~> 2.0.3"}
    ]
  end
end
