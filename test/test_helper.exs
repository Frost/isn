ExUnit.start()
Postgrex.Types.define(ISN.PostgrexTypes, [ISN], [])

defmodule ISN.TestHelper do
  def conn_options do
    db_options = [
      sync_connect: true,
      hostname: "localhost",
      types: ISN.PostgrexTypes,
      database: "isn_test"
    ]

    db_user = System.get_env("POSTGRES_USER", "isn")
    db_pass = System.get_env("POSTGRES_PASSWORD", "isn")

    db_options =
      if db_user do
        Keyword.put(db_options, :username, db_user)
      else
        db_options
      end

    db_options =
      if db_pass do
        Keyword.put(db_options, :password, db_pass)
      else
        db_options
      end

    db_options
  end

  defmacro query(pid, statement, params) do
    quote bind_quoted: [pid: pid, statement: statement, params: params] do
      case Postgrex.query!(pid, statement, params, []) do
        %Postgrex.Result{rows: nil} -> :ok
        %Postgrex.Result{rows: rows} -> rows
        %Postgrex.Error{} = err -> err
      end
    end
  end
end

db_options = Keyword.merge(ISN.TestHelper.conn_options(), database: "postgres")
{:ok, pid} = Postgrex.start_link(db_options)

Postgrex.query!(pid, "DROP DATABASE IF EXISTS isn_test;", [])
Postgrex.query!(pid, "CREATE DATABASE isn_test;", [])
{:ok, pid} = Postgrex.start_link(ISN.TestHelper.conn_options())
Postgrex.query!(pid, "CREATE EXTENSION isn;", [])
