defmodule ExMoexLive.MarketsTest do
  use ExMoexLive.DataCase

  alias ExMoexLive.Markets

  describe "markets" do
    alias ExMoexLive.Markets.Market

    import ExMoexLive.MarketsFixtures

    @invalid_attrs %{has_candles: nil, has_delay: nil, has_extra_yields: nil, has_history: nil, has_history_files: nil, has_history_trades_files: nil, has_orderbook: nil, has_trades: nil, has_tradingsession: nil, is_otc: nil, market_id: nil, market_name: nil, market_title: nil, marketplace: nil, trade_engine_id: nil, trade_engine_name: nil, trade_engine_title: nil}

    test "list_markets/0 returns all markets" do
      market = market_fixture()
      assert Markets.list_markets() == [market]
    end

    test "get_market!/1 returns the market with given id" do
      market = market_fixture()
      assert Markets.get_market!(market.id) == market
    end

    test "create_market/1 with valid data creates a market" do
      valid_attrs = %{has_candles: 42, has_delay: 42, has_extra_yields: 42, has_history: 42, has_history_files: 42, has_history_trades_files: 42, has_orderbook: 42, has_trades: 42, has_tradingsession: 42, is_otc: 42, market_id: 42, market_name: "some market_name", market_title: "some market_title", marketplace: "some marketplace", trade_engine_id: 42, trade_engine_name: "some trade_engine_name", trade_engine_title: "some trade_engine_title"}

      assert {:ok, %Market{} = market} = Markets.create_market(valid_attrs)
      assert market.has_candles == 42
      assert market.has_delay == 42
      assert market.has_extra_yields == 42
      assert market.has_history == 42
      assert market.has_history_files == 42
      assert market.has_history_trades_files == 42
      assert market.has_orderbook == 42
      assert market.has_trades == 42
      assert market.has_tradingsession == 42
      assert market.is_otc == 42
      assert market.market_id == 42
      assert market.market_name == "some market_name"
      assert market.market_title == "some market_title"
      assert market.marketplace == "some marketplace"
      assert market.trade_engine_id == 42
      assert market.trade_engine_name == "some trade_engine_name"
      assert market.trade_engine_title == "some trade_engine_title"
    end

    test "create_market/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Markets.create_market(@invalid_attrs)
    end

    test "update_market/2 with valid data updates the market" do
      market = market_fixture()
      update_attrs = %{has_candles: 43, has_delay: 43, has_extra_yields: 43, has_history: 43, has_history_files: 43, has_history_trades_files: 43, has_orderbook: 43, has_trades: 43, has_tradingsession: 43, is_otc: 43, market_id: 43, market_name: "some updated market_name", market_title: "some updated market_title", marketplace: "some updated marketplace", trade_engine_id: 43, trade_engine_name: "some updated trade_engine_name", trade_engine_title: "some updated trade_engine_title"}

      assert {:ok, %Market{} = market} = Markets.update_market(market, update_attrs)
      assert market.has_candles == 43
      assert market.has_delay == 43
      assert market.has_extra_yields == 43
      assert market.has_history == 43
      assert market.has_history_files == 43
      assert market.has_history_trades_files == 43
      assert market.has_orderbook == 43
      assert market.has_trades == 43
      assert market.has_tradingsession == 43
      assert market.is_otc == 43
      assert market.market_id == 43
      assert market.market_name == "some updated market_name"
      assert market.market_title == "some updated market_title"
      assert market.marketplace == "some updated marketplace"
      assert market.trade_engine_id == 43
      assert market.trade_engine_name == "some updated trade_engine_name"
      assert market.trade_engine_title == "some updated trade_engine_title"
    end

    test "update_market/2 with invalid data returns error changeset" do
      market = market_fixture()
      assert {:error, %Ecto.Changeset{}} = Markets.update_market(market, @invalid_attrs)
      assert market == Markets.get_market!(market.id)
    end

    test "delete_market/1 deletes the market" do
      market = market_fixture()
      assert {:ok, %Market{}} = Markets.delete_market(market)
      assert_raise Ecto.NoResultsError, fn -> Markets.get_market!(market.id) end
    end

    test "change_market/1 returns a market changeset" do
      market = market_fixture()
      assert %Ecto.Changeset{} = Markets.change_market(market)
    end
  end
end
