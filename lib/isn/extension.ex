defmodule Isn.Extension do
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
