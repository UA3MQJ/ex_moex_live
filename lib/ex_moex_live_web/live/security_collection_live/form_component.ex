defmodule ExMoexLiveWeb.SecurityCollectionLive.FormComponent do
  use ExMoexLiveWeb, :live_component

  alias ExMoexLive.SecurityCollections

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage security_collection records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="security_collection-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:security_group_id]} type="number" label="Security group" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Security collection</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{security_collection: security_collection} = assigns, socket) do
    changeset = SecurityCollections.change_security_collection(security_collection)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"security_collection" => security_collection_params}, socket) do
    changeset =
      socket.assigns.security_collection
      |> SecurityCollections.change_security_collection(security_collection_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"security_collection" => security_collection_params}, socket) do
    save_security_collection(socket, socket.assigns.action, security_collection_params)
  end

  defp save_security_collection(socket, :edit, security_collection_params) do
    case SecurityCollections.update_security_collection(socket.assigns.security_collection, security_collection_params) do
      {:ok, security_collection} ->
        notify_parent({:saved, security_collection})

        {:noreply,
         socket
         |> put_flash(:info, "Security collection updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_security_collection(socket, :new, security_collection_params) do
    case SecurityCollections.create_security_collection(security_collection_params) do
      {:ok, security_collection} ->
        notify_parent({:saved, security_collection})

        {:noreply,
         socket
         |> put_flash(:info, "Security collection created successfully")
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
