defmodule ISN.Mixfile do
  use Mix.Project

  @version "2.0.0"

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
    [applications: [:postgrex, :ecto]]
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
      {:postgrex, ">= 0.13.2"},
      {:ecto, ">= 2.1.4"},
      {:credo, "~> 0.7", only: :dev},
      {:ex_doc, "~> 0.15", only: :dev}
    ]
  end
end
