defmodule ExMoexLive.SecurityTypes.SecurityType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "security_types" do
    field :security_group_name, :string
    field :security_type_name, :string
    field :security_type_title, :string
    field :stock_type, :string
    field :trade_engine_id, :integer
    field :trade_engine_name, :string
    field :trade_engine_title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(security_type, attrs) do
    security_type
    |> cast(attrs, [:id, :trade_engine_id, :trade_engine_name, :trade_engine_title, :security_type_name, :security_type_title, :security_group_name, :stock_type])
    |> validate_required([:id, :trade_engine_id, :trade_engine_name, :trade_engine_title, :security_type_name, :security_type_title, :security_group_name])
  end
end
