defmodule ExMoexLiveWeb.SecurityTypeLiveTest do
  use ExMoexLiveWeb.ConnCase

  import Phoenix.LiveViewTest
  import ExMoexLive.SecurityTypesFixtures

  @create_attrs %{security_group_name: "some security_group_name", security_type_name: "some security_type_name", security_type_title: "some security_type_title", stock_type: "some stock_type", trade_engine_id: 42, trade_engine_name: "some trade_engine_name", trade_engine_title: "some trade_engine_title"}
  @update_attrs %{security_group_name: "some updated security_group_name", security_type_name: "some updated security_type_name", security_type_title: "some updated security_type_title", stock_type: "some updated stock_type", trade_engine_id: 43, trade_engine_name: "some updated trade_engine_name", trade_engine_title: "some updated trade_engine_title"}
  @invalid_attrs %{security_group_name: nil, security_type_name: nil, security_type_title: nil, stock_type: nil, trade_engine_id: nil, trade_engine_name: nil, trade_engine_title: nil}

  defp create_security_type(_) do
    security_type = security_type_fixture()
    %{security_type: security_type}
  end

  describe "Index" do
    setup [:create_security_type]

    test "lists all security_types", %{conn: conn, security_type: security_type} do
      {:ok, _index_live, html} = live(conn, ~p"/security_types")

      assert html =~ "Listing Security types"
      assert html =~ security_type.security_group_name
    end

    test "saves new security_type", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/security_types")

      assert index_live |> element("a", "New Security type") |> render_click() =~
               "New Security type"

      assert_patch(index_live, ~p"/security_types/new")

      assert index_live
             |> form("#security_type-form", security_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#security_type-form", security_type: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/security_types")

      html = render(index_live)
      assert html =~ "Security type created successfully"
      assert html =~ "some security_group_name"
    end

    test "updates security_type in listing", %{conn: conn, security_type: security_type} do
      {:ok, index_live, _html} = live(conn, ~p"/security_types")

      assert index_live |> element("#security_types-#{security_type.id} a", "Edit") |> render_click() =~
               "Edit Security type"

      assert_patch(index_live, ~p"/security_types/#{security_type}/edit")

      assert index_live
             |> form("#security_type-form", security_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#security_type-form", security_type: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/security_types")

      html = render(index_live)
      assert html =~ "Security type updated successfully"
      assert html =~ "some updated security_group_name"
    end

    test "deletes security_type in listing", %{conn: conn, security_type: security_type} do
      {:ok, index_live, _html} = live(conn, ~p"/security_types")

      assert index_live |> element("#security_types-#{security_type.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#security_types-#{security_type.id}")
    end
  end

  describe "Show" do
    setup [:create_security_type]

    test "displays security_type", %{conn: conn, security_type: security_type} do
      {:ok, _show_live, html} = live(conn, ~p"/security_types/#{security_type}")

      assert html =~ "Show Security type"
      assert html =~ security_type.security_group_name
    end

    test "updates security_type within modal", %{conn: conn, security_type: security_type} do
      {:ok, show_live, _html} = live(conn, ~p"/security_types/#{security_type}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Security type"

      assert_patch(show_live, ~p"/security_types/#{security_type}/show/edit")

      assert show_live
             |> form("#security_type-form", security_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#security_type-form", security_type: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/security_types/#{security_type}")

      html = render(show_live)
      assert html =~ "Security type updated successfully"
      assert html =~ "some updated security_group_name"
    end
  end
end
