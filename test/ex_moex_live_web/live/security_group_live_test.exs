defmodule ExMoexLiveWeb.SecurityGroupLiveTest do
  use ExMoexLiveWeb.ConnCase

  import Phoenix.LiveViewTest
  import ExMoexLive.SecurityGroupsFixtures

  @create_attrs %{is_hidden: 42, name: "some name", title: "some title"}
  @update_attrs %{is_hidden: 43, name: "some updated name", title: "some updated title"}
  @invalid_attrs %{is_hidden: nil, name: nil, title: nil}

  defp create_security_group(_) do
    security_group = security_group_fixture()
    %{security_group: security_group}
  end

  describe "Index" do
    setup [:create_security_group]

    test "lists all security_groups", %{conn: conn, security_group: security_group} do
      {:ok, _index_live, html} = live(conn, ~p"/security_groups")

      assert html =~ "Listing Security groups"
      assert html =~ security_group.name
    end

    test "saves new security_group", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/security_groups")

      assert index_live |> element("a", "New Security group") |> render_click() =~
               "New Security group"

      assert_patch(index_live, ~p"/security_groups/new")

      assert index_live
             |> form("#security_group-form", security_group: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#security_group-form", security_group: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/security_groups")

      html = render(index_live)
      assert html =~ "Security group created successfully"
      assert html =~ "some name"
    end

    test "updates security_group in listing", %{conn: conn, security_group: security_group} do
      {:ok, index_live, _html} = live(conn, ~p"/security_groups")

      assert index_live |> element("#security_groups-#{security_group.id} a", "Edit") |> render_click() =~
               "Edit Security group"

      assert_patch(index_live, ~p"/security_groups/#{security_group}/edit")

      assert index_live
             |> form("#security_group-form", security_group: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#security_group-form", security_group: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/security_groups")

      html = render(index_live)
      assert html =~ "Security group updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes security_group in listing", %{conn: conn, security_group: security_group} do
      {:ok, index_live, _html} = live(conn, ~p"/security_groups")

      assert index_live |> element("#security_groups-#{security_group.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#security_groups-#{security_group.id}")
    end
  end

  describe "Show" do
    setup [:create_security_group]

    test "displays security_group", %{conn: conn, security_group: security_group} do
      {:ok, _show_live, html} = live(conn, ~p"/security_groups/#{security_group}")

      assert html =~ "Show Security group"
      assert html =~ security_group.name
    end

    test "updates security_group within modal", %{conn: conn, security_group: security_group} do
      {:ok, show_live, _html} = live(conn, ~p"/security_groups/#{security_group}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Security group"

      assert_patch(show_live, ~p"/security_groups/#{security_group}/show/edit")

      assert show_live
             |> form("#security_group-form", security_group: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#security_group-form", security_group: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/security_groups/#{security_group}")

      html = render(show_live)
      assert html =~ "Security group updated successfully"
      assert html =~ "some updated name"
    end
  end
end
