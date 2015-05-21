ExUnit.start()

{:ok, pid} = Postgrex.Connection.start_link(
  hostname: "localhost",
  database: "postgres"
)

Postgrex.Connection.query!(pid, "DROP DATABASE IF EXISTS isn_test;", [])
Postgrex.Connection.query!(pid, "CREATE DATABASE isn_test;", [])
{:ok, pid} = Postgrex.Connection.start_link(
  hostname: "localhost",
  database: "isn_test"
)
Postgrex.Connection.query!(pid, "CREATE EXTENSION isn;", [])

defmodule Isn.TestHelper do
  defmacro query(pid, statement, params) do
    quote bind_quoted: [pid: pid, statement: statement, params: params] do
      case Postgrex.Connection.query(pid, statement, params, []) do
        {:ok, %Postgrex.Result{rows: nil}} -> :ok
        {:ok, %Postgrex.Result{rows: rows}} -> rows
        {:error, %Postgrex.Error{} = err} -> err
      end
    end
  end
end
