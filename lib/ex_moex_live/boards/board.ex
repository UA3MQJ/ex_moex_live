defmodule ExMoexLive.Boards.Board do
  use Ecto.Schema
  import Ecto.Changeset

  schema "boards" do
    field :board_group_id, :integer
    field :board_title, :string
    field :boardid, :string
    field :engine_id, :integer
    field :has_candles, :integer
    field :is_primary, :integer
    field :is_traded, :integer
    field :market_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:id, :board_group_id, :engine_id, :market_id, :boardid, :board_title, :is_traded, :has_candles, :is_primary])
    |> validate_required([:id, :board_group_id, :engine_id, :market_id, :boardid, :board_title, :is_traded, :has_candles, :is_primary])
  end
end
