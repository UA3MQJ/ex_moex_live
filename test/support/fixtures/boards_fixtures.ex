defmodule ExMoexLive.BoardsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExMoexLive.Boards` context.
  """

  @doc """
  Generate a board.
  """
  def board_fixture(attrs \\ %{}) do
    {:ok, board} =
      attrs
      |> Enum.into(%{
        board_group_id: 42,
        board_title: "some board_title",
        boardid: "some boardid",
        engine_id: 42,
        has_candles: 42,
        is_primary: 42,
        is_traded: 42,
        market_id: 42
      })
      |> ExMoexLive.Boards.create_board()

    board
  end
end
