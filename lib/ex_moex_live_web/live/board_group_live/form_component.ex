defmodule ExMoexLiveWeb.BoardGroupLive.FormComponent do
  use ExMoexLiveWeb, :live_component

  alias ExMoexLive.BoardGroups

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage board_group records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="board_group-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:trade_engine_id]} type="number" label="Trade engine" />
        <.input field={@form[:trade_engine_name]} type="text" label="Trade engine name" />
        <.input field={@form[:trade_engine_title]} type="text" label="Trade engine title" />
        <.input field={@form[:market_id]} type="number" label="Market" />
        <.input field={@form[:market_name]} type="text" label="Market name" />
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:is_default]} type="number" label="Is default" />
        <.input field={@form[:board_group_id]} type="number" label="Board group" />
        <.input field={@form[:is_traded]} type="number" label="Is traded" />
        <.input field={@form[:is_order_driven]} type="number" label="Is order driven" />
        <.input field={@form[:category]} type="text" label="Category" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Board group</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{board_group: board_group} = assigns, socket) do
    changeset = BoardGroups.change_board_group(board_group)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"board_group" => board_group_params}, socket) do
    changeset =
      socket.assigns.board_group
      |> BoardGroups.change_board_group(board_group_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"board_group" => board_group_params}, socket) do
    save_board_group(socket, socket.assigns.action, board_group_params)
  end

  defp save_board_group(socket, :edit, board_group_params) do
    case BoardGroups.update_board_group(socket.assigns.board_group, board_group_params) do
      {:ok, board_group} ->
        notify_parent({:saved, board_group})

        {:noreply,
         socket
         |> put_flash(:info, "Board group updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_board_group(socket, :new, board_group_params) do
    case BoardGroups.create_board_group(board_group_params) do
      {:ok, board_group} ->
        notify_parent({:saved, board_group})

        {:noreply,
         socket
         |> put_flash(:info, "Board group created successfully")
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
