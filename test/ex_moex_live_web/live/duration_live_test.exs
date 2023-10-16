defmodule ExMoexLiveWeb.DurationLiveTest do
  use ExMoexLiveWeb.ConnCase

  import Phoenix.LiveViewTest
  import ExMoexLive.DurationsFixtures

  @create_attrs %{days: 42, duration: 42, hint: "some hint", interval: 42, title: "some title"}
  @update_attrs %{days: 43, duration: 43, hint: "some updated hint", interval: 43, title: "some updated title"}
  @invalid_attrs %{days: nil, duration: nil, hint: nil, interval: nil, title: nil}

  defp create_duration(_) do
    duration = duration_fixture()
    %{duration: duration}
  end

  describe "Index" do
    setup [:create_duration]

    test "lists all durations", %{conn: conn, duration: duration} do
      {:ok, _index_live, html} = live(conn, ~p"/durations")

      assert html =~ "Listing Durations"
      assert html =~ duration.hint
    end

    test "saves new duration", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/durations")

      assert index_live |> element("a", "New Duration") |> render_click() =~
               "New Duration"

      assert_patch(index_live, ~p"/durations/new")

      assert index_live
             |> form("#duration-form", duration: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#duration-form", duration: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/durations")

      html = render(index_live)
      assert html =~ "Duration created successfully"
      assert html =~ "some hint"
    end

    test "updates duration in listing", %{conn: conn, duration: duration} do
      {:ok, index_live, _html} = live(conn, ~p"/durations")

      assert index_live |> element("#durations-#{duration.id} a", "Edit") |> render_click() =~
               "Edit Duration"

      assert_patch(index_live, ~p"/durations/#{duration}/edit")

      assert index_live
             |> form("#duration-form", duration: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#duration-form", duration: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/durations")

      html = render(index_live)
      assert html =~ "Duration updated successfully"
      assert html =~ "some updated hint"
    end

    test "deletes duration in listing", %{conn: conn, duration: duration} do
      {:ok, index_live, _html} = live(conn, ~p"/durations")

      assert index_live |> element("#durations-#{duration.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#durations-#{duration.id}")
    end
  end

  describe "Show" do
    setup [:create_duration]

    test "displays duration", %{conn: conn, duration: duration} do
      {:ok, _show_live, html} = live(conn, ~p"/durations/#{duration}")

      assert html =~ "Show Duration"
      assert html =~ duration.hint
    end

    test "updates duration within modal", %{conn: conn, duration: duration} do
      {:ok, show_live, _html} = live(conn, ~p"/durations/#{duration}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Duration"

      assert_patch(show_live, ~p"/durations/#{duration}/show/edit")

      assert show_live
             |> form("#duration-form", duration: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#duration-form", duration: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/durations/#{duration}")

      html = render(show_live)
      assert html =~ "Duration updated successfully"
      assert html =~ "some updated hint"
    end
  end
end
