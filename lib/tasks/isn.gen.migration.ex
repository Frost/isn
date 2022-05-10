defmodule Mix.Tasks.Isn.Gen.Migration do
  use Mix.Task
  import Mix.Ecto
  import Mix.EctoSQL
  import Mix.Generator

  @migration_name "CreateISNExtension"

  @shortdoc "Generate an Ecto migration to add the `isn` extension"

  @moduledoc """
  Generate an Ecto migration to add the `isn` extension to your database.

  ## Example

      mix isn.gen.migration
  """

  @doc false
  def run(args) do
    Mix.Task.run("app.start", args)
    now = Calendar.strftime(DateTime.utc_now(), "%Y%m%d%H%M%S")

    with [repo] <- parse_repo(args),
         filename <- "#{now}_create_isn_extension.exs",
         path <- Path.join(source_repo_priv(repo), "migrations"),
         file <- Path.join(path, filename),
         mod <- Module.concat([repo, Migrations, @migration_name]) do
      create_directory(path)
      create_file(file, migration_template(mod: mod))
    end
  end

  embed_template(:migration, """
  defmodule <%= inspect @mod %> do
    use Ecto.Migration

    def up do
      execute "CREATE EXTENSION IF NOT EXISTS isn;"
    end

    def down do
      execute "DROP EXTENSION IF EXISTS isn;"
    end
  end
  """)
end
