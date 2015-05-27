defmodule Isn.ISSNTest do
  use ExUnit.Case, async: true

  @test_issn "1436-4522"

  test "cast" do
    assert Isn.ISSN.cast(@test_issn) == {:ok, @test_issn}
    assert Isn.ISSN.cast(nil) == :error
  end

  test "load" do
    assert Isn.ISSN.load(@test_issn) == {:ok, @test_issn}
  end

  test "dump" do
    assert Isn.ISSN.dump(@test_issn) == {:ok, @test_issn}
  end
end

