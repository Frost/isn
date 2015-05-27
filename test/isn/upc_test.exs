defmodule Isn.UPCTest do
  use ExUnit.Case, async: true

  @test_upc "220356483481"

  test "cast" do
    assert Isn.UPC.cast(@test_upc) == {:ok, @test_upc}
    assert Isn.UPC.cast(nil) == :error
  end

  test "load" do
    assert Isn.UPC.load(@test_upc) == {:ok, @test_upc}
  end

  test "dump" do
    assert Isn.UPC.dump(@test_upc) == {:ok, @test_upc}
  end
end


