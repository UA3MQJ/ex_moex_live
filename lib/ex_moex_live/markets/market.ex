defmodule ExMoexLive.Markets.Market do
  use Ecto.Schema
  import Ecto.Changeset

  schema "markets" do
    field :has_candles, :integer
    field :has_delay, :integer
    field :has_extra_yields, :integer
    field :has_history, :integer
    field :has_history_files, :integer
    field :has_history_trades_files, :integer
    field :has_orderbook, :integer
    field :has_trades, :integer
    field :has_tradingsession, :integer
    field :is_otc, :integer
    field :market_id, :integer
    field :market_name, :string
    field :market_title, :string
    field :marketplace, :string
    field :trade_engine_id, :integer
    field :trade_engine_name, :string
    field :trade_engine_title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(market, attrs) do
    market
    |> cast(attrs, [:id, :trade_engine_id, :trade_engine_name, :trade_engine_title, :market_name, :market_title, :market_id, :marketplace, :is_otc, :has_history_files, :has_history_trades_files, :has_trades, :has_history, :has_candles, :has_orderbook, :has_tradingsession, :has_extra_yields, :has_delay])
    |> validate_required([:id, :trade_engine_id, :trade_engine_name, :trade_engine_title, :market_name, :market_title, :market_id, :is_otc, :has_history_files, :has_history_trades_files, :has_trades, :has_history, :has_candles, :has_orderbook, :has_tradingsession, :has_extra_yields, :has_delay])
  end
end
