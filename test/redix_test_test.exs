defmodule RedixTestTest do
  use ExUnit.Case
  doctest RedixTest

  test "greets the world" do
    assert RedixTest.hello() == :world
  end
end
