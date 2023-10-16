defmodule ExMoexLiveWeb.SecurityCollectionLive.Index do
  use ExMoexLiveWeb, :live_view

  alias ExMoexLive.SecurityCollections
  alias ExMoexLive.SecurityCollections.SecurityCollection

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :security_collections, SecurityCollections.list_security_collections())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Security collection")
    |> assign(:security_collection, SecurityCollections.get_security_collection!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Security collection")
    |> assign(:security_collection, %SecurityCollection{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Security collections")
    |> assign(:security_collection, nil)
  end

  @impl true
  def handle_info({ExMoexLiveWeb.SecurityCollectionLive.FormComponent, {:saved, security_collection}}, socket) do
    {:noreply, stream_insert(socket, :security_collections, security_collection)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    security_collection = SecurityCollections.get_security_collection!(id)
    {:ok, _} = SecurityCollections.delete_security_collection(security_collection)

    {:noreply, stream_delete(socket, :security_collections, security_collection)}
  end
end
