defmodule ExMoexLiveWeb.SecurityTypeLive.Index do
  use ExMoexLiveWeb, :live_view

  alias ExMoexLive.SecurityTypes
  alias ExMoexLive.SecurityTypes.SecurityType

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :security_types, SecurityTypes.list_security_types())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Security type")
    |> assign(:security_type, SecurityTypes.get_security_type!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Security type")
    |> assign(:security_type, %SecurityType{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Security types")
    |> assign(:security_type, nil)
  end

  @impl true
  def handle_info({ExMoexLiveWeb.SecurityTypeLive.FormComponent, {:saved, security_type}}, socket) do
    {:noreply, stream_insert(socket, :security_types, security_type)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    security_type = SecurityTypes.get_security_type!(id)
    {:ok, _} = SecurityTypes.delete_security_type(security_type)

    {:noreply, stream_delete(socket, :security_types, security_type)}
  end
end
