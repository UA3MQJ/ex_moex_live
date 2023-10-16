defmodule ExMoexLiveWeb.MarketLiveTest do
  use ExMoexLiveWeb.ConnCase

  import Phoenix.LiveViewTest
  import ExMoexLive.MarketsFixtures

  @create_attrs %{has_candles: 42, has_delay: 42, has_extra_yields: 42, has_history: 42, has_history_files: 42, has_history_trades_files: 42, has_orderbook: 42, has_trades: 42, has_tradingsession: 42, is_otc: 42, market_id: 42, market_name: "some market_name", market_title: "some market_title", marketplace: "some marketplace", trade_engine_id: 42, trade_engine_name: "some trade_engine_name", trade_engine_title: "some trade_engine_title"}
  @update_attrs %{has_candles: 43, has_delay: 43, has_extra_yields: 43, has_history: 43, has_history_files: 43, has_history_trades_files: 43, has_orderbook: 43, has_trades: 43, has_tradingsession: 43, is_otc: 43, market_id: 43, market_name: "some updated market_name", market_title: "some updated market_title", marketplace: "some updated marketplace", trade_engine_id: 43, trade_engine_name: "some updated trade_engine_name", trade_engine_title: "some updated trade_engine_title"}
  @invalid_attrs %{has_candles: nil, has_delay: nil, has_extra_yields: nil, has_history: nil, has_history_files: nil, has_history_trades_files: nil, has_orderbook: nil, has_trades: nil, has_tradingsession: nil, is_otc: nil, market_id: nil, market_name: nil, market_title: nil, marketplace: nil, trade_engine_id: nil, trade_engine_name: nil, trade_engine_title: nil}

  defp create_market(_) do
    market = market_fixture()
    %{market: market}
  end

  describe "Index" do
    setup [:create_market]

    test "lists all markets", %{conn: conn, market: market} do
      {:ok, _index_live, html} = live(conn, ~p"/markets")

      assert html =~ "Listing Markets"
      assert html =~ market.market_name
    end

    test "saves new market", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/markets")

      assert index_live |> element("a", "New Market") |> render_click() =~
               "New Market"

      assert_patch(index_live, ~p"/markets/new")

      assert index_live
             |> form("#market-form", market: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#market-form", market: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/markets")

      html = render(index_live)
      assert html =~ "Market created successfully"
      assert html =~ "some market_name"
    end

    test "updates market in listing", %{conn: conn, market: market} do
      {:ok, index_live, _html} = live(conn, ~p"/markets")

      assert index_live |> element("#markets-#{market.id} a", "Edit") |> render_click() =~
               "Edit Market"

      assert_patch(index_live, ~p"/markets/#{market}/edit")

      assert index_live
             |> form("#market-form", market: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#market-form", market: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/markets")

      html = render(index_live)
      assert html =~ "Market updated successfully"
      assert html =~ "some updated market_name"
    end

    test "deletes market in listing", %{conn: conn, market: market} do
      {:ok, index_live, _html} = live(conn, ~p"/markets")

      assert index_live |> element("#markets-#{market.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#markets-#{market.id}")
    end
  end

  describe "Show" do
    setup [:create_market]

    test "displays market", %{conn: conn, market: market} do
      {:ok, _show_live, html} = live(conn, ~p"/markets/#{market}")

      assert html =~ "Show Market"
      assert html =~ market.market_name
    end

    test "updates market within modal", %{conn: conn, market: market} do
      {:ok, show_live, _html} = live(conn, ~p"/markets/#{market}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Market"

      assert_patch(show_live, ~p"/markets/#{market}/show/edit")

      assert show_live
             |> form("#market-form", market: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#market-form", market: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/markets/#{market}")

      html = render(show_live)
      assert html =~ "Market updated successfully"
      assert html =~ "some updated market_name"
    end
  end
end
