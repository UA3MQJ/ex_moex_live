defmodule ExMoexLiveWeb.DurationLive.Index do
  use ExMoexLiveWeb, :live_view

  alias ExMoexLive.Durations
  alias ExMoexLive.Durations.Duration

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :durations, Durations.list_durations())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"duration" => duration}) do
    socket
    |> assign(:page_title, "Edit Duration")
    |> assign(:duration, Durations.get_duration!(duration))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Duration")
    |> assign(:duration, %Duration{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Durations")
    |> assign(:duration, nil)
  end

  @impl true
  def handle_info({ExMoexLiveWeb.DurationLive.FormComponent, {:saved, duration}}, socket) do
    {:noreply, stream_insert(socket, :durations, duration)}
  end

  @impl true
  def handle_event("delete", %{"duration" => duration}, socket) do
    duration = Durations.get_duration!(duration)
    {:ok, _} = Durations.delete_duration(duration)

    {:noreply, stream_delete(socket, :durations, duration)}
  end
end
