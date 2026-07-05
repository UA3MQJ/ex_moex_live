defmodule ExMoexLive.IndicatorsTest do
  use ExUnit.Case, async: true

  alias ExMoexLive.Indicators

  describe "rsi/2" do
    test "returns nils when not enough data" do
      assert Indicators.rsi([1, 2, 3], 14) == [nil, nil, nil]
    end

    test "returns numeric values for sufficient data" do
      closes = Enum.map(1..20, &(&1 * 1.0))
      result = Indicators.rsi(closes, 14)

      assert length(result) == 20
      assert Enum.all?(Enum.take(result, 14), &is_nil/1)
      assert Enum.all?(Enum.drop(result, 14), &is_number/1)
    end

    test "returns 100 when only gains" do
      closes = Enum.map(0..20, &(&1 * 1.0))
      result = Indicators.rsi(closes, 14)

      assert Enum.at(result, 14) == 100.0
    end
  end

  describe "stoch_rsi/2" do
    test "returns k and d series" do
      rsi_values = Enum.map(1..30, fn i -> rem(i, 10) * 10.0 end)
      {k, d} = Indicators.stoch_rsi(rsi_values)

      assert length(k) == length(rsi_values)
      assert length(d) == length(rsi_values)
      assert Enum.any?(k, &is_number/1)
      assert Enum.any?(d, &is_number/1)
    end
  end

  describe "enrich/1" do
    test "builds chart-ready data from candles" do
      candles =
        Enum.map(1..30, fn i ->
          %{
            open: i * 1.0,
            high: i * 1.0 + 1,
            low: i * 1.0 - 1,
            close: i * 1.0,
            volume: 100,
            time: i
          }
        end)

      result = Indicators.enrich(candles)

      assert map_size(result) == 4
      assert length(result.candles) == 30
      assert is_list(result.rsi)
      assert is_list(result.stoch_k)
      assert is_list(result.stoch_d)

      assert Enum.all?(result.rsi, fn %{time: t, value: v} ->
        is_integer(t) and is_number(v)
      end)
    end
  end
end
