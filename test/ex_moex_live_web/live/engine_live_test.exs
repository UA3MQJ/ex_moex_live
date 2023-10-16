defmodule ExMoexLiveWeb.EngineLiveTest do
  use ExMoexLiveWeb.ConnCase

  import Phoenix.LiveViewTest
  import ExMoexLive.EnginesFixtures

  @create_attrs %{name: "some name", title: "some title"}
  @update_attrs %{name: "some updated name", title: "some updated title"}
  @invalid_attrs %{name: nil, title: nil}

  defp create_engine(_) do
    engine = engine_fixture()
    %{engine: engine}
  end

  describe "Index" do
    setup [:create_engine]

    test "lists all engines", %{conn: conn, engine: engine} do
      {:ok, _index_live, html} = live(conn, ~p"/engines")

      assert html =~ "Listing Engines"
      assert html =~ engine.name
    end

    test "saves new engine", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/engines")

      assert index_live |> element("a", "New Engine") |> render_click() =~
               "New Engine"

      assert_patch(index_live, ~p"/engines/new")

      assert index_live
             |> form("#engine-form", engine: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#engine-form", engine: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/engines")

      html = render(index_live)
      assert html =~ "Engine created successfully"
      assert html =~ "some name"
    end

    test "updates engine in listing", %{conn: conn, engine: engine} do
      {:ok, index_live, _html} = live(conn, ~p"/engines")

      assert index_live |> element("#engines-#{engine.id} a", "Edit") |> render_click() =~
               "Edit Engine"

      assert_patch(index_live, ~p"/engines/#{engine}/edit")

      assert index_live
             |> form("#engine-form", engine: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#engine-form", engine: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/engines")

      html = render(index_live)
      assert html =~ "Engine updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes engine in listing", %{conn: conn, engine: engine} do
      {:ok, index_live, _html} = live(conn, ~p"/engines")

      assert index_live |> element("#engines-#{engine.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#engines-#{engine.id}")
    end
  end

  describe "Show" do
    setup [:create_engine]

    test "displays engine", %{conn: conn, engine: engine} do
      {:ok, _show_live, html} = live(conn, ~p"/engines/#{engine}")

      assert html =~ "Show Engine"
      assert html =~ engine.name
    end

    test "updates engine within modal", %{conn: conn, engine: engine} do
      {:ok, show_live, _html} = live(conn, ~p"/engines/#{engine}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Engine"

      assert_patch(show_live, ~p"/engines/#{engine}/show/edit")

      assert show_live
             |> form("#engine-form", engine: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#engine-form", engine: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/engines/#{engine}")

      html = render(show_live)
      assert html =~ "Engine updated successfully"
      assert html =~ "some updated name"
    end
  end
end
