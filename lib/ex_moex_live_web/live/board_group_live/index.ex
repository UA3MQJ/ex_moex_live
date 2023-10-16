defmodule ExMoexLiveWeb.BoardGroupLive.Index do
  use ExMoexLiveWeb, :live_view

  alias ExMoexLive.BoardGroups
  alias ExMoexLive.BoardGroups.BoardGroup

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :board_groups, BoardGroups.list_board_groups())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Board group")
    |> assign(:board_group, BoardGroups.get_board_group!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Board group")
    |> assign(:board_group, %BoardGroup{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Board groups")
    |> assign(:board_group, nil)
  end

  @impl true
  def handle_info({ExMoexLiveWeb.BoardGroupLive.FormComponent, {:saved, board_group}}, socket) do
    {:noreply, stream_insert(socket, :board_groups, board_group)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    board_group = BoardGroups.get_board_group!(id)
    {:ok, _} = BoardGroups.delete_board_group(board_group)

    {:noreply, stream_delete(socket, :board_groups, board_group)}
  end
end
