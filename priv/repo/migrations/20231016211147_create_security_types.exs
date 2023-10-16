defmodule ExMoexLive.Repo.Migrations.CreateSecurityTypes do
  use Ecto.Migration

  def change do
    create table(:security_types) do
      add :trade_engine_id, :integer
      add :trade_engine_name, :string
      add :trade_engine_title, :string
      add :security_type_name, :string
      add :security_type_title, :string
      add :security_group_name, :string
      add :stock_type, :string

      timestamps(type: :utc_datetime)
    end
  end
end
