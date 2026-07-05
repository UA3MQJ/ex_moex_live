defmodule ExMoexLive.DurationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExMoexLive.Durations` context.
  """

  import ExMoexLive.FixtureHelpers

  @doc """
  Generate a duration.
  """
  def duration_fixture(attrs \\ %{}) do
    interval = Map.get(attrs, :interval) || unique_id()

    attrs =
      attrs
      |> Enum.into(%{
        days: 42,
        duration: interval,
        hint: "some hint",
        interval: interval,
        title: "some title"
      })

    {:ok, _duration} = ExMoexLive.Durations.create_duration(attrs)
    ExMoexLive.Durations.get_duration!(interval)
  end
end
