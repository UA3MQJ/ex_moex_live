defmodule ExMoexLive.EnginesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExMoexLive.Engines` context.
  """

  import ExMoexLive.FixtureHelpers

  @doc """
  Generate a engine.
  """
  def engine_fixture(attrs \\ %{}) do
    {:ok, engine} =
      attrs
      |> Enum.into(%{
        id: unique_id(),
        name: "some name",
        title: "some title"
      })
      |> ExMoexLive.Engines.create_engine()

    engine
  end
end
