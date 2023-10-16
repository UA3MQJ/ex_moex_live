defmodule ExMoexLive.Repo.Migrations.CreateBoards do
  use Ecto.Migration

  def change do
    create table(:boards) do
      add :board_group_id, :integer
      add :engine_id, :integer
      add :market_id, :integer
      add :boardid, :string
      add :board_title, :string
      add :is_traded, :integer
      add :has_candles, :integer
      add :is_primary, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
