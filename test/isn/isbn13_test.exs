defmodule Isn.ISBN13Test do
  use ExUnit.Case, async: true

  @test_isbn "978-1-937785-58-1"

  test "cast" do
    assert Isn.ISBN13.cast(@test_isbn) == {:ok, @test_isbn}
    assert Isn.ISBN13.cast(nil) == :error
  end

  test "load" do
    assert Isn.ISBN13.load(@test_isbn) == {:ok, @test_isbn}
  end

  test "dump" do
    assert Isn.ISBN13.dump(@test_isbn) == {:ok, @test_isbn}
  end
end
