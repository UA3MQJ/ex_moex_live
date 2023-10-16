defmodule ExMoexLiveWeb.SecurityCollectionLive.Show do
  use ExMoexLiveWeb, :live_view

  alias ExMoexLive.SecurityCollections

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:security_collection, SecurityCollections.get_security_collection!(id))}
  end

  defp page_title(:show), do: "Show Security collection"
  defp page_title(:edit), do: "Edit Security collection"
end
