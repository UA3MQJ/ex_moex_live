defmodule ExMoexLiveWeb.SecurityGroupLive.Show do
  use ExMoexLiveWeb, :live_view

  alias ExMoexLive.SecurityGroups

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:security_group, SecurityGroups.get_security_group!(id))}
  end

  defp page_title(:show), do: "Show Security group"
  defp page_title(:edit), do: "Edit Security group"
end
