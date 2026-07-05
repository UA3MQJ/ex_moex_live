defmodule ExMoexLive.Indicators do
  @moduledoc """
  Technical indicators computed from candle close prices.
  """

  @default_rsi_period 14
  @default_stoch_period 14
  @default_k_period 3
  @default_d_period 3

  @doc """
  Computes RSI using Wilder's smoothing method.

  Returns a list the same length as `closes`, with `nil` for indices
  where RSI is not yet defined.
  """
  def rsi(closes, period \\ @default_rsi_period) do
    n = length(closes)

    if n <= period do
      List.duplicate(nil, n)
    else
      deltas =
        for i <- 1..(n - 1) do
          Enum.at(closes, i) - Enum.at(closes, i - 1)
        end

      gains = Enum.map(deltas, fn d -> if d > 0, do: d * 1.0, else: 0.0 end)
      losses = Enum.map(deltas, fn d -> if d < 0, do: -d * 1.0, else: 0.0 end)

      avg_gain = Enum.sum(Enum.take(gains, period)) / period
      avg_loss = Enum.sum(Enum.take(losses, period)) / period

      first_rsi = rsi_value(avg_gain, avg_loss)

      {rest_rsis, _} =
        Enum.reduce((period..(length(deltas) - 1)), {[], {avg_gain, avg_loss}}, fn i, {acc, {ag, al}} ->
          g = Enum.at(gains, i)
          l = Enum.at(losses, i)
          new_ag = (ag * (period - 1) + g) / period
          new_al = (al * (period - 1) + l) / period
          {[rsi_value(new_ag, new_al) | acc], {new_ag, new_al}}
        end)

      List.duplicate(nil, period) ++ [first_rsi | Enum.reverse(rest_rsis)]
    end
  end

  @doc """
  Computes StochRSI (%K and %D) from an RSI series.

  Returns `{k_values, d_values}` lists aligned with the input RSI series.
  """
  def stoch_rsi(rsi_values, opts \\ []) do
    stoch_period = Keyword.get(opts, :stoch_period, @default_stoch_period)
    k_period = Keyword.get(opts, :k_period, @default_k_period)
    d_period = Keyword.get(opts, :d_period, @default_d_period)

    raw_stoch =
      rsi_values
      |> Enum.with_index()
      |> Enum.map(fn {val, idx} ->
        if is_nil(val) or idx < stoch_period - 1 do
          nil
        else
          window =
            rsi_values
            |> Enum.slice((idx - stoch_period + 1)..idx)
            |> Enum.filter(&is_number/1)

          if length(window) < stoch_period do
            nil
          else
            low = Enum.min(window)
            high = Enum.max(window)
            current = val

            if high == low do
              0.0
            else
              (current - low) / (high - low) * 100
            end
          end
        end
      end)

    k_values = sma_list(raw_stoch, k_period)
    d_values = sma_list(k_values, d_period)

    {k_values, d_values}
  end

  @doc """
  Enriches candles with RSI14 and StochRSI indicator series.

  Returns a map suitable for JSON encoding and the chart hook.
  """
  def enrich(candles) when is_list(candles) do
    closes = Enum.map(candles, & &1.close)
    rsi_values = rsi(closes)
    {stoch_k, stoch_d} = stoch_rsi(rsi_values)

    %{
      candles: candles,
      rsi: series(candles, rsi_values),
      stoch_k: series(candles, stoch_k),
      stoch_d: series(candles, stoch_d)
    }
  end

  defp rsi_value(_avg_gain, avg_loss) when avg_loss == 0.0, do: 100.0

  defp rsi_value(avg_gain, avg_loss) do
    rs = avg_gain / avg_loss
    100.0 - 100.0 / (1.0 + rs)
  end

  defp sma_list(values, period) do
    values
    |> Enum.with_index()
    |> Enum.map(fn {val, idx} ->
      if is_nil(val) or idx < period - 1 do
        nil
      else
        window =
          values
          |> Enum.slice((idx - period + 1)..idx)
          |> Enum.filter(&is_number/1)

        if length(window) == period do
          Enum.sum(window) / period
        else
          nil
        end
      end
    end)
  end

  defp series(candles, values) do
    candles
    |> Enum.zip(values)
    |> Enum.flat_map(fn
      {_candle, nil} -> []
      {candle, value} -> [%{time: candle.time, value: Float.round(value * 1.0, 2)}]
    end)
  end
end
