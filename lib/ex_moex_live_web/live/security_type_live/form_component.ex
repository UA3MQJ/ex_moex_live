defmodule ExMoexLiveWeb.SecurityTypeLive.FormComponent do
  use ExMoexLiveWeb, :live_component

  alias ExMoexLive.SecurityTypes

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage security_type records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="security_type-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:trade_engine_id]} type="number" label="Trade engine" />
        <.input field={@form[:trade_engine_name]} type="text" label="Trade engine name" />
        <.input field={@form[:trade_engine_title]} type="text" label="Trade engine title" />
        <.input field={@form[:security_type_name]} type="text" label="Security type name" />
        <.input field={@form[:security_type_title]} type="text" label="Security type title" />
        <.input field={@form[:security_group_name]} type="text" label="Security group name" />
        <.input field={@form[:stock_type]} type="text" label="Stock type" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Security type</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{security_type: security_type} = assigns, socket) do
    changeset = SecurityTypes.change_security_type(security_type)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"security_type" => security_type_params}, socket) do
    changeset =
      socket.assigns.security_type
      |> SecurityTypes.change_security_type(security_type_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"security_type" => security_type_params}, socket) do
    save_security_type(socket, socket.assigns.action, security_type_params)
  end

  defp save_security_type(socket, :edit, security_type_params) do
    case SecurityTypes.update_security_type(socket.assigns.security_type, security_type_params) do
      {:ok, security_type} ->
        notify_parent({:saved, security_type})

        {:noreply,
         socket
         |> put_flash(:info, "Security type updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_security_type(socket, :new, security_type_params) do
    case SecurityTypes.create_security_type(security_type_params) do
      {:ok, security_type} ->
        notify_parent({:saved, security_type})

        {:noreply,
         socket
         |> put_flash(:info, "Security type created successfully")
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
