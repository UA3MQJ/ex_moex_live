defmodule ExMoexLiveWeb.BoardLiveTest do
  use ExMoexLiveWeb.ConnCase

  import Phoenix.LiveViewTest
  import ExMoexLive.BoardsFixtures

  @create_attrs %{board_group_id: 42, board_title: "some board_title", boardid: "some boardid", engine_id: 42, has_candles: 42, is_primary: 42, is_traded: 42, market_id: 42}
  @update_attrs %{board_group_id: 43, board_title: "some updated board_title", boardid: "some updated boardid", engine_id: 43, has_candles: 43, is_primary: 43, is_traded: 43, market_id: 43}
  @invalid_attrs %{board_group_id: nil, board_title: nil, boardid: nil, engine_id: nil, has_candles: nil, is_primary: nil, is_traded: nil, market_id: nil}

  defp create_board(_) do
    board = board_fixture()
    %{board: board}
  end

  describe "Index" do
    setup [:create_board]

    test "lists all boards", %{conn: conn, board: board} do
      {:ok, _index_live, html} = live(conn, ~p"/boards")

      assert html =~ "Listing Boards"
      assert html =~ board.board_title
    end

    test "saves new board", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/boards")

      assert index_live |> element("a", "New Board") |> render_click() =~
               "New Board"

      assert_patch(index_live, ~p"/boards/new")

      assert index_live
             |> form("#board-form", board: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#board-form", board: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/boards")

      html = render(index_live)
      assert html =~ "Board created successfully"
      assert html =~ "some board_title"
    end

    test "updates board in listing", %{conn: conn, board: board} do
      {:ok, index_live, _html} = live(conn, ~p"/boards")

      assert index_live |> element("#boards-#{board.id} a", "Edit") |> render_click() =~
               "Edit Board"

      assert_patch(index_live, ~p"/boards/#{board}/edit")

      assert index_live
             |> form("#board-form", board: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#board-form", board: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/boards")

      html = render(index_live)
      assert html =~ "Board updated successfully"
      assert html =~ "some updated board_title"
    end

    test "deletes board in listing", %{conn: conn, board: board} do
      {:ok, index_live, _html} = live(conn, ~p"/boards")

      assert index_live |> element("#boards-#{board.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#boards-#{board.id}")
    end
  end

  describe "Show" do
    setup [:create_board]

    test "displays board", %{conn: conn, board: board} do
      {:ok, _show_live, html} = live(conn, ~p"/boards/#{board}")

      assert html =~ "Show Board"
      assert html =~ board.board_title
    end

    test "updates board within modal", %{conn: conn, board: board} do
      {:ok, show_live, _html} = live(conn, ~p"/boards/#{board}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Board"

      assert_patch(show_live, ~p"/boards/#{board}/show/edit")

      assert show_live
             |> form("#board-form", board: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#board-form", board: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/boards/#{board}")

      html = render(show_live)
      assert html =~ "Board updated successfully"
      assert html =~ "some updated board_title"
    end
  end
end
