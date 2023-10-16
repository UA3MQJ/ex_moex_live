defmodule ExMoexLive.BoardGroups.BoardGroup do
  use Ecto.Schema
  import Ecto.Changeset

  schema "board_groups" do
    field :board_group_id, :integer
    field :category, :string
    field :is_default, :integer
    field :is_order_driven, :integer
    field :is_traded, :integer
    field :market_id, :integer
    field :market_name, :string
    field :name, :string
    field :title, :string
    field :trade_engine_id, :integer
    field :trade_engine_name, :string
    field :trade_engine_title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(board_group, attrs) do
    board_group
    |> cast(attrs, [:id, :trade_engine_id, :trade_engine_name, :trade_engine_title, :market_id, :market_name, :name, :title, :is_default, :board_group_id, :is_traded, :is_order_driven, :category])
    |> validate_required([:id, :trade_engine_id, :trade_engine_name, :trade_engine_title, :market_id, :market_name, :name, :title, :is_default, :board_group_id, :is_traded, :category])
  end
end
