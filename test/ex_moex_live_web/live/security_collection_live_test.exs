defmodule ExMoexLiveWeb.SecurityCollectionLiveTest do
  use ExMoexLiveWeb.ConnCase

  import Phoenix.LiveViewTest
  import ExMoexLive.SecurityCollectionsFixtures

  @create_attrs %{name: "some name", security_group_id: 42, title: "some title"}
  @update_attrs %{name: "some updated name", security_group_id: 43, title: "some updated title"}
  @invalid_attrs %{name: nil, security_group_id: nil, title: nil}

  defp create_security_collection(_) do
    security_collection = security_collection_fixture()
    %{security_collection: security_collection}
  end

  describe "Index" do
    setup [:create_security_collection]

    test "lists all security_collections", %{conn: conn, security_collection: security_collection} do
      {:ok, _index_live, html} = live(conn, ~p"/security_collections")

      assert html =~ "Listing Security collections"
      assert html =~ security_collection.name
    end

    test "saves new security_collection", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/security_collections")

      assert index_live |> element("a", "New Security collection") |> render_click() =~
               "New Security collection"

      assert_patch(index_live, ~p"/security_collections/new")

      assert index_live
             |> form("#security_collection-form", security_collection: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#security_collection-form", security_collection: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/security_collections")

      html = render(index_live)
      assert html =~ "Security collection created successfully"
      assert html =~ "some name"
    end

    test "updates security_collection in listing", %{conn: conn, security_collection: security_collection} do
      {:ok, index_live, _html} = live(conn, ~p"/security_collections")

      assert index_live |> element("#security_collections-#{security_collection.id} a", "Edit") |> render_click() =~
               "Edit Security collection"

      assert_patch(index_live, ~p"/security_collections/#{security_collection}/edit")

      assert index_live
             |> form("#security_collection-form", security_collection: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#security_collection-form", security_collection: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/security_collections")

      html = render(index_live)
      assert html =~ "Security collection updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes security_collection in listing", %{conn: conn, security_collection: security_collection} do
      {:ok, index_live, _html} = live(conn, ~p"/security_collections")

      assert index_live |> element("#security_collections-#{security_collection.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#security_collections-#{security_collection.id}")
    end
  end

  describe "Show" do
    setup [:create_security_collection]

    test "displays security_collection", %{conn: conn, security_collection: security_collection} do
      {:ok, _show_live, html} = live(conn, ~p"/security_collections/#{security_collection}")

      assert html =~ "Show Security collection"
      assert html =~ security_collection.name
    end

    test "updates security_collection within modal", %{conn: conn, security_collection: security_collection} do
      {:ok, show_live, _html} = live(conn, ~p"/security_collections/#{security_collection}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Security collection"

      assert_patch(show_live, ~p"/security_collections/#{security_collection}/show/edit")

      assert show_live
             |> form("#security_collection-form", security_collection: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#security_collection-form", security_collection: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/security_collections/#{security_collection}")

      html = render(show_live)
      assert html =~ "Security collection updated successfully"
      assert html =~ "some updated name"
    end
  end
end
