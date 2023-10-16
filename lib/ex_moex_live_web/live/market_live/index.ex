defmodule ExMoexLiveWeb.MarketLive.Index do
  use ExMoexLiveWeb, :live_view

  alias ExMoexLive.Markets
  alias ExMoexLive.Markets.Market

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :markets, Markets.list_markets())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Market")
    |> assign(:market, Markets.get_market!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Market")
    |> assign(:market, %Market{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Markets")
    |> assign(:market, nil)
  end

  @impl true
  def handle_info({ExMoexLiveWeb.MarketLive.FormComponent, {:saved, market}}, socket) do
    {:noreply, stream_insert(socket, :markets, market)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    market = Markets.get_market!(id)
    {:ok, _} = Markets.delete_market(market)

    {:noreply, stream_delete(socket, :markets, market)}
  end
end
