defmodule IsnTest do
  use ExUnit.Case, async: true
  import Isn.TestHelper
  alias Postgrex.Connection, as: P

  setup do
    options = Keyword.merge(conn_options, [extensions: [{Isn, {}}]])
    {:ok, pid} = P.start_link(options)
    {:ok, [pid: pid]}
  end

  test "encode and decode isbn", context do
    assert [["1-937785-58-0"]] =
           query(context[:pid], "SELECT $1::isbn", ['1937785580'])
  end

  test "encode and decode isbn13", context do
    assert [["978-1-937785-58-1"]] =
           query(context[:pid], "SELECT $1::isbn13", ['9781937785581'])
  end

  test "encode and decode ismn", context do
    assert [["M-060-11561-5"]] =
           query(context[:pid], "SELECT $1::ismn", ['9790060115615'])
  end

  test "encode and decode ismn13", context do
    assert [["979-0-060-11561-5"]] =
           query(context[:pid], "SELECT $1::ismn13", ['9790060115615'])
  end

  test "encode and decode issn", context do
    assert [["1436-4522"]] =
           query(context[:pid], "SELECT $1::issn", ['14364522'])
  end

  test "encode and decode issn13", context do
    assert [["977-1436-452-00-8"]] =
           query(context[:pid], "SELECT issn13(issn('1436-4522'))", [])
  end

  test "encode and decode ean13", context do
    assert [["022-035648348-1"]] =
           query(context[:pid], "SELECT $1::ean13", ["0220356483481"])
  end

  test "encode and decode upc", context do
    assert [["220356483481"]] =
           query(context[:pid], "SELECT $1::upc", ["220356483481"])
  end
end

