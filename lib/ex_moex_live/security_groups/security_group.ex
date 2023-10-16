defmodule ExMoexLive.SecurityGroups.SecurityGroup do
  use Ecto.Schema
  import Ecto.Changeset

  schema "security_groups" do
    field :is_hidden, :integer
    field :name, :string
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(security_group, attrs) do
    security_group
    |> cast(attrs, [:id, :name, :title, :is_hidden])
    |> validate_required([:id, :name, :title, :is_hidden])
  end
end
