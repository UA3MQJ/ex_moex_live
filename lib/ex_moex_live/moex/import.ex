defmodule ExMoexLive.MOEX.Import do
  @moduledoc false

  alias ExMoexLive.Repo

  def upsert_rows(%{"columns" => columns, "data" => rows}, schema, conflict_target)
      when is_list(columns) and is_list(rows) do
    Enum.each(rows, fn row ->
      row
      |> row_to_map(columns)
      |> then(&schema.changeset(struct(schema), &1))
      |> Repo.insert!(on_conflict: :nothing, conflict_target: conflict_target, returning: false)
    end)
  end

  defp row_to_map(row, columns), do: Map.new(Enum.zip(columns, row))
end
