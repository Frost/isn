defmodule Isn.Base do
  defmacro __using__(type) do
    quote bind_quoted: [type: type] do
      # @behaviour Ecto.Type
      #
      @moduledoc """
      Definition for the #{@type} module.
      """

      def type,
        do: type

      defdelegate blank?, to: Ecto.Type

      def cast(isn), do: {:ok, to_string(isn)}
      def load(isn), do: {:ok, to_string(isn)}
      def dump(isn), do: {:ok, to_string(isn)}
    end
  end
end
