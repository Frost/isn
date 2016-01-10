defmodule ISN.ISMN13Test do
  use ExUnit.Case, async: true

  @test_ismn "979-0-060-11561-5"

  test "cast" do
    assert ISN.ISMN13.cast(@test_ismn) == {:ok, @test_ismn}
    assert ISN.ISMN13.cast(nil) == :error
  end

  test "load" do
    assert ISN.ISMN13.load(@test_ismn) == {:ok, @test_ismn}
  end

  test "dump" do
    assert ISN.ISMN13.dump(@test_ismn) == {:ok, @test_ismn}
  end
end
