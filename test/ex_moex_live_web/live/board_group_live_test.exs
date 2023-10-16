defmodule ExMoexLiveWeb.BoardGroupLiveTest do
  use ExMoexLiveWeb.ConnCase

  import Phoenix.LiveViewTest
  import ExMoexLive.BoardGroupsFixtures

  @create_attrs %{board_group_id: 42, category: "some category", is_default: 42, is_order_driven: 42, is_traded: 42, market_id: 42, market_name: "some market_name", name: "some name", title: "some title", trade_engine_id: 42, trade_engine_name: "some trade_engine_name", trade_engine_title: "some trade_engine_title"}
  @update_attrs %{board_group_id: 43, category: "some updated category", is_default: 43, is_order_driven: 43, is_traded: 43, market_id: 43, market_name: "some updated market_name", name: "some updated name", title: "some updated title", trade_engine_id: 43, trade_engine_name: "some updated trade_engine_name", trade_engine_title: "some updated trade_engine_title"}
  @invalid_attrs %{board_group_id: nil, category: nil, is_default: nil, is_order_driven: nil, is_traded: nil, market_id: nil, market_name: nil, name: nil, title: nil, trade_engine_id: nil, trade_engine_name: nil, trade_engine_title: nil}

  defp create_board_group(_) do
    board_group = board_group_fixture()
    %{board_group: board_group}
  end

  describe "Index" do
    setup [:create_board_group]

    test "lists all board_groups", %{conn: conn, board_group: board_group} do
      {:ok, _index_live, html} = live(conn, ~p"/board_groups")

      assert html =~ "Listing Board groups"
      assert html =~ board_group.category
    end

    test "saves new board_group", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/board_groups")

      assert index_live |> element("a", "New Board group") |> render_click() =~
               "New Board group"

      assert_patch(index_live, ~p"/board_groups/new")

      assert index_live
             |> form("#board_group-form", board_group: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#board_group-form", board_group: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/board_groups")

      html = render(index_live)
      assert html =~ "Board group created successfully"
      assert html =~ "some category"
    end

    test "updates board_group in listing", %{conn: conn, board_group: board_group} do
      {:ok, index_live, _html} = live(conn, ~p"/board_groups")

      assert index_live |> element("#board_groups-#{board_group.id} a", "Edit") |> render_click() =~
               "Edit Board group"

      assert_patch(index_live, ~p"/board_groups/#{board_group}/edit")

      assert index_live
             |> form("#board_group-form", board_group: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#board_group-form", board_group: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/board_groups")

      html = render(index_live)
      assert html =~ "Board group updated successfully"
      assert html =~ "some updated category"
    end

    test "deletes board_group in listing", %{conn: conn, board_group: board_group} do
      {:ok, index_live, _html} = live(conn, ~p"/board_groups")

      assert index_live |> element("#board_groups-#{board_group.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#board_groups-#{board_group.id}")
    end
  end

  describe "Show" do
    setup [:create_board_group]

    test "displays board_group", %{conn: conn, board_group: board_group} do
      {:ok, _show_live, html} = live(conn, ~p"/board_groups/#{board_group}")

      assert html =~ "Show Board group"
      assert html =~ board_group.category
    end

    test "updates board_group within modal", %{conn: conn, board_group: board_group} do
      {:ok, show_live, _html} = live(conn, ~p"/board_groups/#{board_group}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Board group"

      assert_patch(show_live, ~p"/board_groups/#{board_group}/show/edit")

      assert show_live
             |> form("#board_group-form", board_group: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#board_group-form", board_group: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/board_groups/#{board_group}")

      html = render(show_live)
      assert html =~ "Board group updated successfully"
      assert html =~ "some updated category"
    end
  end
end
