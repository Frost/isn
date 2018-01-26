defmodule ISN.ISBNTest do
  use ExUnit.Case, async: true

  @test_isbn "1-937785-58-0"

  test "cast" do
    assert ISN.ISBN.cast(@test_isbn) == {:ok, @test_isbn}
    assert ISN.ISBN.cast(nil) == :error
  end

  test "load" do
    assert ISN.ISBN.load(@test_isbn) == {:ok, @test_isbn}
  end

  test "dump" do
    assert ISN.ISBN.dump(@test_isbn) == {:ok, @test_isbn}
  end
end
