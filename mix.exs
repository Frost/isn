defmodule Isn.Mixfile do
  use Mix.Project

  @version "0.1.1"

  def project do
    [app: :isn,
     version: @version,
     elixir: "~> 1.0",
     deps: deps,
     test_paths: ["test"],
     # Hex
     description: description,
     package: package,
     # Docs
     name: "Isn",
     docs: [source_ref: "v#{@version}",
            source_url: "https://github.com/Frost/isn"]
   ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:postgrex]]
  end

  defp description do
    """
    Ecto types for the postgreSQL isn extension.
    """
  end

  defp package do
    [files: ~w(lib README.md mix.exs),
     contributors: ["Martin Frost"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/Frost/isn"}]
  end

  defp deps do
    [{:postgrex, "~> 0.9"},
     {:ecto, "~> 1.0"},
     {:eh, "~> 0.2", only: :dev},
     {:ex_doc, "~> 0.10", only: :dev},
     {:earmark, ">= 0.0.0", only: :dev}]
  end
end
