defmodule ExMoexLiveWeb.SecurityGroupLive.FormComponent do
  use ExMoexLiveWeb, :live_component

  alias ExMoexLive.SecurityGroups

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage security_group records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="security_group-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:is_hidden]} type="number" label="Is hidden" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Security group</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{security_group: security_group} = assigns, socket) do
    changeset = SecurityGroups.change_security_group(security_group)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"security_group" => security_group_params}, socket) do
    changeset =
      socket.assigns.security_group
      |> SecurityGroups.change_security_group(security_group_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"security_group" => security_group_params}, socket) do
    save_security_group(socket, socket.assigns.action, security_group_params)
  end

  defp save_security_group(socket, :edit, security_group_params) do
    case SecurityGroups.update_security_group(socket.assigns.security_group, security_group_params) do
      {:ok, security_group} ->
        notify_parent({:saved, security_group})

        {:noreply,
         socket
         |> put_flash(:info, "Security group updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_security_group(socket, :new, security_group_params) do
    case SecurityGroups.create_security_group(security_group_params) do
      {:ok, security_group} ->
        notify_parent({:saved, security_group})

        {:noreply,
         socket
         |> put_flash(:info, "Security group created successfully")
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
