defmodule ExMoexLive.Repo.Migrations.CreateSecurityGroups do
  use Ecto.Migration

  def change do
    create table(:security_groups) do
      add :name, :string
      add :title, :string
      add :is_hidden, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
