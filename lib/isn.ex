defmodule ISN do
  @behaviour Postgrex.Extension
  @isn ~w(ean13 isbn13 ismn13 issn13 isbn ismn issn upc)

  @moduledoc """
  A Postgrex.Extension enabling the use of postgresql data types from the isn
  extension.

  In lib/ directory create a file with the following content:

    Postgrex.Types.define(
      MyApp.PostgrexTypes,
      [ISN] ++ Ecto.Adapters.Postgres.extensions(),
      json: Poison
    )

  Add the following lines in conig.exs:

    config :my_app, MyApp.Repo,
      types: MyApp.PostgrexTypes

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
          field :isbn, ISN.ISBN13, read_after_writes: true
          # other fields
        end
      end
  """

  def init(opts), do: Keyword.get(opts, :decode_copy, :reference)

  def matching(_), do: Enum.zip(Stream.cycle([:type]), @isn)

  def format(_), do: :text

  def encode(_opts) do
    quote do
      thing ->
        [<<IO.iodata_length(thing)::int32>> | thing]
    end
  end

  def decode(:copy) do
    quote do
      <<len::int32, thing::binary-size(len)>> ->
        :binary.copy(thing)
    end
  end

  def decode(:reference) do
    quote do
      <<len::int32, thing::binary-size(len)>> ->
        thing
    end
  end
end

# Generate Ecto.Type modules for all supported data types in the `isn`
# postgresql module.
for module <- ~w(ISBN ISMN ISSN ISBN13 ISMN13 ISSN13 UPC EAN13) do
  module_name = Module.concat([ISN, module])
  ecto_type = module |> String.downcase() |> String.to_atom()

  defmodule module_name do
    @behaviour Ecto.Type

    @moduledoc """
    Definition for the ISN.#{module} module.

    How to use this in an Ecto.Model

        defmodule MyApp.Book do
          use MyApp.Web, :model

          schema "books" do
            field :#{ecto_type}, ISN.#{module}
            # other fields
          end
        end
    """

    def type, do: unquote(ecto_type)

    def cast(nil), do: :error
    def cast(isn), do: {:ok, to_string(isn)}

    def load(isn), do: {:ok, to_string(isn)}

    def dump(isn), do: {:ok, to_string(isn)}
  end
end
