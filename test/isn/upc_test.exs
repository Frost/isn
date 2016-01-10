defmodule ISN.UPCTest do
  use ExUnit.Case, async: true

  @test_upc "220356483481"

  test "cast" do
    assert ISN.UPC.cast(@test_upc) == {:ok, @test_upc}
    assert ISN.UPC.cast(nil) == :error
  end

  test "load" do
    assert ISN.UPC.load(@test_upc) == {:ok, @test_upc}
  end

  test "dump" do
    assert ISN.UPC.dump(@test_upc) == {:ok, @test_upc}
  end
end


