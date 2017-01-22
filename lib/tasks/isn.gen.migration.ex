defmodule Mix.Tasks.Isn.Gen.Migration do
  use Mix.Task
  import Mix.Ecto
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
    Mix.Task.run "app.start", args
    [repo] = parse_repo(args)
    filename = "#{timestamp()}_create_isn_extension.exs"
    path = Path.relative_to(migrations_path(repo), Mix.Project.app_path)
    file = Path.join(path, filename)
    create_directory(path)
    mod = Module.concat([repo, Migrations, @migration_name])
    create_file(file, migration_template(mod: mod))
  end

  defp timestamp do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end

  defp pad(s), do: s |> to_string() |> String.rjust(2, ?0)

  embed_template :migration, """
  defmodule <%= inspect @mod %> do
    use Ecto.Migration

    def up do
      execute "CREATE EXTENSION IF NOT EXISTS isn;"
    end

    def down do
      execute "DROP EXTENSION IF EXISTS isn;"
    end
  end
  """
end
