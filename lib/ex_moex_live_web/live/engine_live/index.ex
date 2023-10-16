defmodule ExMoexLiveWeb.EngineLive.Index do
  use ExMoexLiveWeb, :live_view

  alias ExMoexLive.Engines
  alias ExMoexLive.Engines.Engine

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :engines, Engines.list_engines())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Engine")
    |> assign(:engine, Engines.get_engine!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Engine")
    |> assign(:engine, %Engine{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Engines")
    |> assign(:engine, nil)
  end

  @impl true
  def handle_info({ExMoexLiveWeb.EngineLive.FormComponent, {:saved, engine}}, socket) do
    {:noreply, stream_insert(socket, :engines, engine)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    engine = Engines.get_engine!(id)
    {:ok, _} = Engines.delete_engine(engine)

    {:noreply, stream_delete(socket, :engines, engine)}
  end
end
