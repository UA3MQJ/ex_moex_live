defmodule ExMoexLive.Repo.Migrations.CreateDurations do
  use Ecto.Migration

  def change do
    create table(:durations, primary_key: false) do
      add :interval, :integer, primary_key: true
      add :duration, :integer
      add :days, :integer
      add :title, :string
      add :hint, :string

      timestamps(type: :utc_datetime)
    end
  end
end
