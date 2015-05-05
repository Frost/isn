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

      def cast(isn), do: {:ok, to_string(isn)}
      def load(isn), do: {:ok, to_string(isn)}
      def dump(isn), do: {:ok, to_string(isn)}
    end
  end
end
