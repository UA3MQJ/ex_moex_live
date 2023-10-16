defmodule ExMoexLiveWeb.SecurityTypeLive.Show do
  use ExMoexLiveWeb, :live_view

  alias ExMoexLive.SecurityTypes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:security_type, SecurityTypes.get_security_type!(id))}
  end

  defp page_title(:show), do: "Show Security type"
  defp page_title(:edit), do: "Edit Security type"
end
