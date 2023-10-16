defmodule ExMoexLive.Repo.Migrations.CreateBoardGroups do
  use Ecto.Migration

  def change do
    create table(:board_groups) do
      add :trade_engine_id, :integer
      add :trade_engine_name, :string
      add :trade_engine_title, :string
      add :market_id, :integer
      add :market_name, :string
      add :name, :string
      add :title, :string
      add :is_default, :integer
      add :board_group_id, :integer
      add :is_traded, :integer
      add :is_order_driven, :integer
      add :category, :string

      timestamps(type: :utc_datetime)
    end
  end
end
