defmodule Isn.Mixfile do
  use Mix.Project

  @version "0.0.1"

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
    []
  end

  defp description do
    """
    Ecto types for the postgreSQL isn extension.
    """
  end

  defp package do
    [contributors: ["Martin Frost"],
     licences: ["MIT"],
     links: %{"GitHub" => "https://github.com/Frost/isn"}]
  end

  defp deps do
    [{:postgrex, "~> 0.8.1"},
     {:ecto, "~> 0.11.0"}]
  end
end