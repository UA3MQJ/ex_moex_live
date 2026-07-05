defmodule ExMoexLive.MOEX.CandlesTest do
  use ExUnit.Case, async: true

  alias ExMoexLive.MOEX.Candles

  @fixture """
  {
    "candles": {
      "columns": ["open", "close", "high", "low", "value", "volume", "begin", "end"],
      "data": [
        [308.69, 303.14, 308.69, 300.51, 3618159889.8, 11904960, "2025-06-01 00:00:00", "2025-06-01 23:59:57"],
        [302.6, 309.63, 311.99, 302, 12643311908.8, 41216150, "2025-06-02 00:00:00", "2025-06-02 23:59:56"]
      ]
    },
    "candles.cursor": {
      "columns": ["INDEX", "TOTAL", "PAGESIZE"],
      "data": [[0, 2, 500]]
    }
  }
  """

  describe "parse/1" do
    test "parses MOEX candles JSON" do
      assert {:ok, candles} = Candles.parse(@fixture)
      assert length(candles) == 2

      [first | _] = candles
      assert first.open == 308.69
      assert first.close == 303.14
      assert first.high == 308.69
      assert first.low == 300.51
      assert first.volume == 11_904_960
      assert is_integer(first.time)
    end

    test "returns empty list when candles key is missing" do
      assert {:ok, []} = Candles.parse(%{"other" => %{}})
    end
  end
end
