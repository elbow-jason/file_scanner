defmodule FileScannerTest do
  use ExUnit.Case
  doctest FileScanner

  test "greets the world" do
    assert FileScanner.hello() == :world
  end
end
