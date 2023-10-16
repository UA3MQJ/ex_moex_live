defmodule ExMoexLive.DurationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExMoexLive.Durations` context.
  """

  @doc """
  Generate a duration.
  """
  def duration_fixture(attrs \\ %{}) do
    {:ok, duration} =
      attrs
      |> Enum.into(%{
        days: 42,
        duration: 42,
        hint: "some hint",
        interval: 42,
        title: "some title"
      })
      |> ExMoexLive.Durations.create_duration()

    duration
  end
end
