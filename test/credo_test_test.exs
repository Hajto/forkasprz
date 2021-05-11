defmodule CredoTestTest do
  use Credo.Test.Case

  test "greets the world" do
    ~S"""
    defmodule TestModule do
      require Logger

      def some_fun() do
        Logger.info("#{inspect(%{a: 2})}")
      end
    end
    """
    |> to_source_file()
    |> run_check(MyFirstCredoCheck)
    |> assert_issues()
  end
end
