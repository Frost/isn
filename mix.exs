defmodule ISN.Mixfile do
  use Mix.Project

  @version "2.0.1"

  def project do
    [
      app: :isn,
      version: @version,
      elixir: "~> 1.0",
      deps: deps(),
      test_paths: ["test"],
      # Hex
      description: description(),
      package: package(),
      # Docs
      name: "ISN",
      docs: [
        source_ref: "v#{@version}",
        source_url: "https://github.com/Frost/isn",
        extras: ["README.md"]
      ]
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:postgrex, :ecto, :ecto_sql]]
  end

  defp description do
    """
    Ecto types for the postgreSQL isn extension.
    """
  end

  defp package do
    [
      files: ~w(lib README.md mix.exs),
      maintainers: ["Martin Frost"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/Frost/isn"}
    ]
  end

  defp deps do
    [
      {:postgrex, "~> 0.16"},
      {:ecto, "~> 3.0"},
      {:ecto_sql, "~> 3.0"},
      {:credo, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, "~> 0.15", only: :dev, runtime: false},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false}
    ]
  end
end
