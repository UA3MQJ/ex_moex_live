defmodule ExMoexLive.Durations.Duration do
  use Ecto.Schema
  import Ecto.Changeset

  # нет id в таблице!
  @primary_key false
  schema "durations" do
    field :id, :integer, virtual: true
    field :days, :integer
    field :duration, :integer
    field :hint, :string
    field :interval, :integer
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  def after_get(%__MODULE__{} = duration, %EctoHooks.Delta{}) do
    %__MODULE__{duration | id: duration.duration}
    # %__MODULE__{duration | id: 1}
  end

  @doc false
  def changeset(duration, attrs) do
    duration
    |> cast(attrs, [:interval, :duration, :days, :title, :hint])
    |> validate_required([:interval, :duration, :title, :hint])
  end
end
