defmodule Isn do
  alias Postgrex.TypeInfo

  @behaviour Postgrex.Extension
  @isn ~w(ean13 isbn13 ismn13 issn13 isbn ismn issn upc)

  @moduledoc """
  A Postgrex.Extension enabling the use of postgresql data types from the isn
  extension.

  Add this module as an extension when establishing your Postgrex connection:

      Postgrex.Connection.start_link(
        database: "isn_test",
        extensions: [{Isn, {}}])

  Then you can do Ecto.Migrations like this:

      defmodule MyApp.Repo.Migrations.CreateBook do
        use Ecto.Migration

        def change do
          create table(:books) do
            add :isbn, :isbn13
            # other fields
          end
        end
      end

  You can also define Ecto.Models using the matching custom Ecto.Types:

      defmodule MyApp.Book do
        use MyApp.Web, :model

        schema "books" do
          field :isbn, Isn.ISBN13
          # other fields
        end
      end
  """

  def init(parameters, _opts),
    do: parameters

  def matching(_library),
    do: Enum.zip(Stream.cycle([:type]), @isn)

  def format(_),
    do: :text

  def encode(%TypeInfo{type: type}, binary, _types, _opts) when type in @isn,
    do: binary

  def decode(%TypeInfo{type: type}, binary, _types, _opts) when type in @isn,
    do: binary
end

for module <- ~w(ISBN ISMN ISSN ISBN13 ISMN13 ISSN13 UPC EAN13) do
  module_name = Module.concat([Isn, module])
  ecto_type = module |> String.downcase |> String.to_atom
  defmodule module_name do
    @behaviour Ecto.Type

    @moduledoc """
    Definition for the #{module_name} module.

    How to use this in an Ecto.Model

    defmodule MyApp.Book do
    use MyApp.Web, :model

    schema "books" do
    field :#{module_name}, Isn.#{ecto_type}
    # other fields
    end
    end
    """

    def type, do: unquote(ecto_type)

    defdelegate blank?, to: Ecto.Type

    def cast(nil), do: :error
    def cast(isn), do: {:ok, to_string(isn)}

    def load(isn), do: {:ok, to_string(isn)}

    def dump(isn), do: {:ok, to_string(isn)}
  end
end
