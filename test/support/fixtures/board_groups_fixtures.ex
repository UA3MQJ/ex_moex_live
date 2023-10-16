defmodule ExMoexLive.BoardGroupsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExMoexLive.BoardGroups` context.
  """

  @doc """
  Generate a board_group.
  """
  def board_group_fixture(attrs \\ %{}) do
    {:ok, board_group} =
      attrs
      |> Enum.into(%{
        board_group_id: 42,
        category: "some category",
        is_default: 42,
        is_order_driven: 42,
        is_traded: 42,
        market_id: 42,
        market_name: "some market_name",
        name: "some name",
        title: "some title",
        trade_engine_id: 42,
        trade_engine_name: "some trade_engine_name",
        trade_engine_title: "some trade_engine_title"
      })
      |> ExMoexLive.BoardGroups.create_board_group()

    board_group
  end
end
