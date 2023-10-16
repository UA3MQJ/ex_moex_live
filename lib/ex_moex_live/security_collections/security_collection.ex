defmodule ExMoexLive.SecurityCollections.SecurityCollection do
  use Ecto.Schema
  import Ecto.Changeset

  schema "security_collections" do
    field :name, :string
    field :security_group_id, :integer
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(security_collection, attrs) do
    security_collection
    |> cast(attrs, [:id, :name, :title, :security_group_id])
    |> validate_required([:id, :name, :title, :security_group_id])
  end
end
