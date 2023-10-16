defmodule ExMoexLiveWeb.BoardLive.FormComponent do
  use ExMoexLiveWeb, :live_component

  alias ExMoexLive.Boards

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage board records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="board-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:board_group_id]} type="number" label="Board group" />
        <.input field={@form[:engine_id]} type="number" label="Engine" />
        <.input field={@form[:market_id]} type="number" label="Market" />
        <.input field={@form[:boardid]} type="text" label="Boardid" />
        <.input field={@form[:board_title]} type="text" label="Board title" />
        <.input field={@form[:is_traded]} type="number" label="Is traded" />
        <.input field={@form[:has_candles]} type="number" label="Has candles" />
        <.input field={@form[:is_primary]} type="number" label="Is primary" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Board</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{board: board} = assigns, socket) do
    changeset = Boards.change_board(board)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"board" => board_params}, socket) do
    changeset =
      socket.assigns.board
      |> Boards.change_board(board_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"board" => board_params}, socket) do
    save_board(socket, socket.assigns.action, board_params)
  end

  defp save_board(socket, :edit, board_params) do
    case Boards.update_board(socket.assigns.board, board_params) do
      {:ok, board} ->
        notify_parent({:saved, board})

        {:noreply,
         socket
         |> put_flash(:info, "Board updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_board(socket, :new, board_params) do
    case Boards.create_board(board_params) do
      {:ok, board} ->
        notify_parent({:saved, board})

        {:noreply,
         socket
         |> put_flash(:info, "Board created successfully")
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
