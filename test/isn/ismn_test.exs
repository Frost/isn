defmodule ISN.ISMNTest do
  use ExUnit.Case, async: true

  @test_ismn "M-060-11561-5"

  test "cast" do
    assert ISN.ISMN.cast(@test_ismn) == {:ok, @test_ismn}
    assert ISN.ISMN.cast(nil) == :error
  end

  test "load" do
    assert ISN.ISMN.load(@test_ismn) == {:ok, @test_ismn}
  end

  test "dump" do
    assert ISN.ISMN.dump(@test_ismn) == {:ok, @test_ismn}
  end
end
