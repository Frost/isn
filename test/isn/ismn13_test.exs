defmodule Isn.ISMN13Test do
  use ExUnit.Case, async: true

  @test_ismn "979-0-060-11561-5"

  test "cast" do
    assert Isn.ISMN13.cast(@test_ismn) == {:ok, @test_ismn}
    assert Isn.ISMN13.cast(nil) == :error
  end

  test "load" do
    assert Isn.ISMN13.load(@test_ismn) == {:ok, @test_ismn}
  end

  test "dump" do
    assert Isn.ISMN13.dump(@test_ismn) == {:ok, @test_ismn}
  end
end
