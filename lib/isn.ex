defmodule Isn do
  alias Postgrex.TypeInfo

  @behaviour Postgrex.Extension
  @isn ~w(ean13 isbn13 ismn13 issn13 isbn ismn issn upc)

  def init(parameters, _opts),
    do: parameters

  def matching(_library),
    do: Enum.reduce(@isn, [], fn(t, ack) -> ack ++ [type: t] end)

  def format(_),
    do: :text

  def encode(%TypeInfo{type: type}, binary, _types, _opts) when type in @isn,
    do: binary

  def decode(%TypeInfo{type: type}, binary, _types, _opts) when type in @isn,
    do: binary
end

defmodule Isn.Base do
  defmacro __using__(isn_type) do
    quote bind_quoted: [isn_type: isn_type] do
      # @behaviour Ecto.Type
      #
      @isn_type isn_type
      @moduledoc """
      Definition for the #{@isn_type} module.
      """

      def type,
        do: @isn_type

      defdelegate blank?, to: Ecto.Type

      def cast(nil), do: :error
      def cast(isn), do: {:ok, to_string(isn)}

      def load(isn), do: {:ok, to_string(isn)}

      def dump(isn), do: {:ok, to_string(isn)}
    end
  end
end

defmodule Isn.ISBN,   do: use(Isn.Base, :isbn)
defmodule Isn.ISMN,   do: use(Isn.Base, :ismn)
defmodule Isn.ISSN,   do: use(Isn.Base, :issn)
defmodule Isn.ISBN13, do: use(Isn.Base, :isbn13)
defmodule Isn.ISMN13, do: use(Isn.Base, :ismn13)
defmodule Isn.ISSN13, do: use(Isn.Base, :issn13)
defmodule Isn.UPC,    do: use(Isn.Base, :upc)
defmodule Isn.EAN13,  do: use(Isn.Base, :ean13)
