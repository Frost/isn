ExUnit.start()

# db_options = [ 
# 	hostname: "localhost",
# 	database: "postgres"]
# 
# db_user = System.get_env("DATABASE_POSTGRESQL_USERNAME")
# db_pass = System.get_env("DATABASE_POSTGRESQL_PASSWORD")
# 
# if db_user, do: db_options = Dict.put(db_options, :username, db_user)
# if db_pass, do: db_options = Dict.put(db_options, :password, db_pass)
# 
# {:ok, pid} = Postgrex.Connection.start_link(db_options)
# 
# Postgrex.Connection.query!(pid, "DROP DATABASE IF EXISTS isn_test;", [])
# Postgrex.Connection.query!(pid, "CREATE DATABASE isn_test;", [])
# conn_options = Keyword.merge(db_options, [database: "isn_test"])
# {:ok, pid} = Postgrex.Connection.start_link(conn_options)
# Postgrex.Connection.query!(pid, "CREATE EXTENSION isn;", [])

defmodule Isn.TestHelper do
	def conn_options do
		db_options = [ 
      sync_connect: true,
			hostname: "localhost",
			database: "isn_test",
      username: "postgres",
      password: ""]

		db_user = System.get_env("DATABASE_POSTGRESQL_USERNAME")
		db_pass = System.get_env("DATABASE_POSTGRESQL_PASSWORD")

		if db_user, do: db_options = Dict.put(db_options, :username, db_user)
		if db_pass, do: db_options = Dict.put(db_options, :password, db_pass)

		db_options
	end

  defmacro query(pid, statement, params) do
    quote bind_quoted: [pid: pid, statement: statement, params: params] do
      case Postgrex.Connection.query!(pid, statement, params, []) do
        %Postgrex.Result{rows: nil} -> :ok
        %Postgrex.Result{rows: rows} -> rows
        %Postgrex.Error{} = err -> err
      end
    end
  end
end

db_options = Keyword.merge(Isn.TestHelper.conn_options, [database: "postgres"])
{:ok, pid} = Postgrex.Connection.start_link(db_options)

Postgrex.Connection.query!(pid, "DROP DATABASE IF EXISTS isn_test;", [])
Postgrex.Connection.query!(pid, "CREATE DATABASE isn_test;", [])
Postgrex.Connection.stop(pid)
{:ok, pid} = Postgrex.Connection.start_link(Isn.TestHelper.conn_options)
Postgrex.Connection.query!(pid, "CREATE EXTENSION isn;", [])
Postgrex.Connection.stop(pid)
