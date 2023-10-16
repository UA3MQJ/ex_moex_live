defmodule ExMoexLiveWeb.MarketLive.FormComponent do
  use ExMoexLiveWeb, :live_component

  alias ExMoexLive.Markets

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage market records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="market-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:trade_engine_id]} type="number" label="Trade engine" />
        <.input field={@form[:trade_engine_name]} type="text" label="Trade engine name" />
        <.input field={@form[:trade_engine_title]} type="text" label="Trade engine title" />
        <.input field={@form[:market_name]} type="text" label="Market name" />
        <.input field={@form[:market_title]} type="text" label="Market title" />
        <.input field={@form[:market_id]} type="number" label="Market" />
        <.input field={@form[:marketplace]} type="text" label="Marketplace" />
        <.input field={@form[:is_otc]} type="number" label="Is otc" />
        <.input field={@form[:has_history_files]} type="number" label="Has history files" />
        <.input field={@form[:has_history_trades_files]} type="number" label="Has history trades files" />
        <.input field={@form[:has_trades]} type="number" label="Has trades" />
        <.input field={@form[:has_history]} type="number" label="Has history" />
        <.input field={@form[:has_candles]} type="number" label="Has candles" />
        <.input field={@form[:has_orderbook]} type="number" label="Has orderbook" />
        <.input field={@form[:has_tradingsession]} type="number" label="Has tradingsession" />
        <.input field={@form[:has_extra_yields]} type="number" label="Has extra yields" />
        <.input field={@form[:has_delay]} type="number" label="Has delay" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Market</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{market: market} = assigns, socket) do
    changeset = Markets.change_market(market)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"market" => market_params}, socket) do
    changeset =
      socket.assigns.market
      |> Markets.change_market(market_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"market" => market_params}, socket) do
    save_market(socket, socket.assigns.action, market_params)
  end

  defp save_market(socket, :edit, market_params) do
    case Markets.update_market(socket.assigns.market, market_params) do
      {:ok, market} ->
        notify_parent({:saved, market})

        {:noreply,
         socket
         |> put_flash(:info, "Market updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_market(socket, :new, market_params) do
    case Markets.create_market(market_params) do
      {:ok, market} ->
        notify_parent({:saved, market})

        {:noreply,
         socket
         |> put_flash(:info, "Market created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
