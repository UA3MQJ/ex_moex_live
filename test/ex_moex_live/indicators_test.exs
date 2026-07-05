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

      assert map_size(result) == 5
      assert length(result.candles) == 30
      assert is_list(result.rsi)
      assert is_list(result.stoch_k)
      assert is_list(result.stoch_d)
      assert is_list(result.signals)

      assert Enum.all?(result.rsi, fn %{time: t, value: v} ->
        is_integer(t) and is_number(v)
      end)
    end
  end

  describe "rsi_divergence_signals/3" do
    test "detects bearish divergence at second pivot high" do
      candles = bearish_divergence_candles()
      rsi_values = divergence_rsi_values(bearish: {75.0, 65.0})

      signals = Indicators.rsi_divergence_signals(candles, rsi_values, lookback: 2)

      assert length(signals) == 1
      assert hd(signals).text == "Продажа"
      assert hd(signals).shape == "arrowDown"
      assert hd(signals).time == 20
    end

    test "detects bullish divergence at second pivot low" do
      candles = bullish_divergence_candles()
      rsi_values = divergence_rsi_values(bullish: {35.0, 45.0})

      signals = Indicators.rsi_divergence_signals(candles, rsi_values, lookback: 2)

      assert length(signals) == 1
      assert hd(signals).text == "Покупка"
      assert hd(signals).shape == "arrowUp"
      assert hd(signals).time == 20
    end

    test "returns empty list when not enough candles" do
      candles = [make_candle(0)]
      rsi_values = [50.0]

      assert Indicators.rsi_divergence_signals(candles, rsi_values) == []
    end
  end

  defp make_candle(time, opts \\ []) do
    low = Keyword.get(opts, :low, 100.0)
    high = Keyword.get(opts, :high, 102.0)
    close = Keyword.get(opts, :close, 101.0)

    %{
      open: close,
      high: high,
      low: low,
      close: close,
      volume: 100,
      time: time
    }
  end

  defp bearish_divergence_candles do
    for i <- 0..30 do
      cond do
        i == 10 -> make_candle(i, high: 110.0, low: 108.0, close: 109.0)
        i == 20 -> make_candle(i, high: 115.0, low: 113.0, close: 114.0)
        i in [8, 9, 11, 12] -> make_candle(i, high: 105.0, low: 103.0, close: 104.0)
        i in [18, 19, 21, 22] -> make_candle(i, high: 112.0, low: 110.0, close: 111.0)
        true -> make_candle(i)
      end
    end
  end

  defp bullish_divergence_candles do
    for i <- 0..30 do
      cond do
        i == 10 -> make_candle(i, high: 92.0, low: 90.0, close: 91.0)
        i == 20 -> make_candle(i, high: 87.0, low: 85.0, close: 86.0)
        i in [8, 9, 11, 12] -> make_candle(i, high: 94.0, low: 92.0, close: 93.0)
        i in [18, 19, 21, 22] -> make_candle(i, high: 89.0, low: 87.0, close: 88.0)
        true -> make_candle(i)
      end
    end
  end

  defp divergence_rsi_values(opts) do
    {first_rsi, second_rsi} =
      cond do
        Keyword.has_key?(opts, :bearish) -> opts[:bearish]
        Keyword.has_key?(opts, :bullish) -> opts[:bullish]
      end

    Enum.map(0..30, fn
      10 -> first_rsi
      20 -> second_rsi
      _ -> 50.0
    end)
  end
end
