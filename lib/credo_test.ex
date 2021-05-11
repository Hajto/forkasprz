defmodule CredoTest do
  @moduledoc """
  Documentation for `CredoTest`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> CredoTest.hello()
      :world

  """
  def hello do
    require Logger
    Logger.info("Test message #{inspect("arg")} trolo")
    Logger.info("Test message #{inspect("arg")} trolo", trol: "olo")
    Logger.warn("Test message #{inspect("arg")} trolo")
    Logger.error("Test message #{inspect("arg")} trolo")
  end
end
