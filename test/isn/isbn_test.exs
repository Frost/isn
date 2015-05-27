defmodule Isn.ISBNTest do
  use ExUnit.Case, async: true

  @test_isbn "1-937785-58-0"

  test "cast" do
    assert Isn.ISBN.cast(@test_isbn) == {:ok, @test_isbn}
    assert Isn.ISBN.cast(nil) == :error
  end

  test "load" do
    assert Isn.ISBN.load(@test_isbn) == {:ok, @test_isbn}
  end

  test "dump" do
    assert Isn.ISBN.dump(@test_isbn) == {:ok, @test_isbn}
  end
end

