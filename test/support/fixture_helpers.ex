defmodule ExMoexLive.FixtureHelpers do
  @moduledoc false

  def unique_id, do: System.unique_integer([:positive])
end
