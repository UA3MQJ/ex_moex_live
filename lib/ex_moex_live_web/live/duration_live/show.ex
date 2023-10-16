defmodule ExMoexLiveWeb.DurationLive.Show do
  use ExMoexLiveWeb, :live_view

  alias ExMoexLive.Durations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"duration" => duration}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:duration, Durations.get_duration!(duration))}
  end

  defp page_title(:show), do: "Show Duration"
  defp page_title(:edit), do: "Edit Duration"
end
