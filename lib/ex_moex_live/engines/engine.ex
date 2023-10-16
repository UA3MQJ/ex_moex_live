defmodule ExMoexLive.Engines.Engine do
  use Ecto.Schema
  import Ecto.Changeset

  schema "engines" do
    field :name, :string
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(engine, attrs) do
    engine
    |> cast(attrs, [:id, :name, :title])
    |> validate_required([:id, :name, :title])
  end
end
