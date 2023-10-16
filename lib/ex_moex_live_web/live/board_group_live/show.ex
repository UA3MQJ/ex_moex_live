defmodule ExMoexLiveWeb.BoardGroupLive.Show do
  use ExMoexLiveWeb, :live_view

  alias ExMoexLive.BoardGroups

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:board_group, BoardGroups.get_board_group!(id))}
  end

  defp page_title(:show), do: "Show Board group"
  defp page_title(:edit), do: "Edit Board group"
end
