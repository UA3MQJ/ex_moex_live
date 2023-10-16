defmodule ExMoexLiveWeb.EngineLive.Show do
  use ExMoexLiveWeb, :live_view

  alias ExMoexLive.Engines

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:engine, Engines.get_engine!(id))}
  end

  defp page_title(:show), do: "Show Engine"
  defp page_title(:edit), do: "Edit Engine"
end
