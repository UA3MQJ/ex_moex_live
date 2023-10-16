defmodule ExMoexLive.Repo.Migrations.CreateSecurityCollections do
  use Ecto.Migration

  def change do
    create table(:security_collections) do
      add :name, :string
      add :title, :string
      add :security_group_id, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
