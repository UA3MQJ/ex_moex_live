defmodule ExMoexLiveWeb.EngineLive.FormComponent do
  use ExMoexLiveWeb, :live_component

  alias ExMoexLive.Engines

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage engine records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="engine-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:title]} type="text" label="Title" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Engine</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{engine: engine} = assigns, socket) do
    changeset = Engines.change_engine(engine)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"engine" => engine_params}, socket) do
    changeset =
      socket.assigns.engine
      |> Engines.change_engine(engine_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"engine" => engine_params}, socket) do
    save_engine(socket, socket.assigns.action, engine_params)
  end

  defp save_engine(socket, :edit, engine_params) do
    case Engines.update_engine(socket.assigns.engine, engine_params) do
      {:ok, engine} ->
        notify_parent({:saved, engine})

        {:noreply,
         socket
         |> put_flash(:info, "Engine updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_engine(socket, :new, engine_params) do
    case Engines.create_engine(engine_params) do
      {:ok, engine} ->
        notify_parent({:saved, engine})

        {:noreply,
         socket
         |> put_flash(:info, "Engine created successfully")
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
