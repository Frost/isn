defmodule ISN.ISSNTest do
  use ExUnit.Case, async: true

  @test_issn "1436-4522"

  test "cast" do
    assert ISN.ISSN.cast(@test_issn) == {:ok, @test_issn}
    assert ISN.ISSN.cast(nil) == :error
  end

  test "load" do
    assert ISN.ISSN.load(@test_issn) == {:ok, @test_issn}
  end

  test "dump" do
    assert ISN.ISSN.dump(@test_issn) == {:ok, @test_issn}
  end
end

