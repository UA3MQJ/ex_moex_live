defmodule ExMoexLiveWeb.DurationLive.FormComponent do
  use ExMoexLiveWeb, :live_component

  alias ExMoexLive.Durations

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage duration records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="duration-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:interval]} type="number" label="Interval" />
        <.input field={@form[:duration]} type="number" label="Duration" />
        # <.input field={@form[:days]} type="number" label="Days" />
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:hint]} type="text" label="Hint" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Duration</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{duration: duration} = assigns, socket) do
    changeset = Durations.change_duration(duration)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"duration" => duration_params}, socket) do
    changeset =
      socket.assigns.duration
      |> Durations.change_duration(duration_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"duration" => duration_params}, socket) do
    save_duration(socket, socket.assigns.action, duration_params)
  end

  defp save_duration(socket, :edit, duration_params) do
    case Durations.update_duration(socket.assigns.duration, duration_params) do
      {:ok, duration} ->
        notify_parent({:saved, duration})

        {:noreply,
         socket
         |> put_flash(:info, "Duration updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_duration(socket, :new, duration_params) do
    case Durations.create_duration(duration_params) do
      {:ok, duration} ->
        notify_parent({:saved, duration})

        {:noreply,
         socket
         |> put_flash(:info, "Duration created successfully")
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
