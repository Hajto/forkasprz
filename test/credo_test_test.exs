defmodule CredoTestTest do
  use Credo.Test.Case
  doctest CredoTest

  test "greets the world" do
    """
    defmodule TestModule do
      require Logger

      def some_fun() do
        Logger.info(#{inspect(%{key: "value"})})
      end
    end
    """
    |> to_source_file()
    |> run_check(MyFirstCredoCheck)
    |> assert_issues()
  end
end
