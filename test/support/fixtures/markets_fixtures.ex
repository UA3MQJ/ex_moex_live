defmodule ExMoexLive.MarketsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExMoexLive.Markets` context.
  """

  @doc """
  Generate a market.
  """
  def market_fixture(attrs \\ %{}) do
    {:ok, market} =
      attrs
      |> Enum.into(%{
        has_candles: 42,
        has_delay: 42,
        has_extra_yields: 42,
        has_history: 42,
        has_history_files: 42,
        has_history_trades_files: 42,
        has_orderbook: 42,
        has_trades: 42,
        has_tradingsession: 42,
        is_otc: 42,
        market_id: 42,
        market_name: "some market_name",
        market_title: "some market_title",
        marketplace: "some marketplace",
        trade_engine_id: 42,
        trade_engine_name: "some trade_engine_name",
        trade_engine_title: "some trade_engine_title"
      })
      |> ExMoexLive.Markets.create_market()

    market
  end
end
