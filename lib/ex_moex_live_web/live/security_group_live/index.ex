defmodule ExMoexLiveWeb.SecurityGroupLive.Index do
  use ExMoexLiveWeb, :live_view

  alias ExMoexLive.SecurityGroups
  alias ExMoexLive.SecurityGroups.SecurityGroup

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :security_groups, SecurityGroups.list_security_groups())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Security group")
    |> assign(:security_group, SecurityGroups.get_security_group!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Security group")
    |> assign(:security_group, %SecurityGroup{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Security groups")
    |> assign(:security_group, nil)
  end

  @impl true
  def handle_info({ExMoexLiveWeb.SecurityGroupLive.FormComponent, {:saved, security_group}}, socket) do
    {:noreply, stream_insert(socket, :security_groups, security_group)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    security_group = SecurityGroups.get_security_group!(id)
    {:ok, _} = SecurityGroups.delete_security_group(security_group)

    {:noreply, stream_delete(socket, :security_groups, security_group)}
  end
end
