defmodule Isn.ISMNTest do
  use ExUnit.Case, async: true

  @test_ismn "M-060-11561-5"

  test "cast" do
    assert Isn.ISMN.cast(@test_ismn) == {:ok, @test_ismn}
    assert Isn.ISMN.cast(nil) == :error
  end

  test "load" do
    assert Isn.ISMN.load(@test_ismn) == {:ok, @test_ismn}
  end

  test "dump" do
    assert Isn.ISMN.dump(@test_ismn) == {:ok, @test_ismn}
  end
end

