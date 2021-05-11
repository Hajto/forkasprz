defmodule CredoTestTest do
  use ExUnit.Case
  doctest CredoTest

  test "greets the world" do
    assert CredoTest.hello() == :world
  end
end
