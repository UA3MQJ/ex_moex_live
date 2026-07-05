defmodule ExMoexLive.MOEX.Candles do
  @moduledoc """
  Fetches candle data from the MOEX ISS API.
  """

  require Logger

  @base_url "https://iss.moex.com/iss/engines"

  @doc """
  Fetches candles for a security.

  ## Options

    * `:from` - start date as `Date` (required)
    * `:till` - end date as `Date` (required)
    * `:interval` - candle interval in MOEX units (default: 24 = daily)

  ## Examples

      ExMoexLive.MOEX.Candles.fetch("stock", "shares", "TQBR", "SBER",
        from: ~D[2025-01-01],
        till: ~D[2025-06-01]
      )
  """
  def fetch(engine, market, board, ticker, opts) do
    from = Keyword.fetch!(opts, :from)
    till = Keyword.fetch!(opts, :till)
    interval = Keyword.get(opts, :interval, 24)

    url =
      "#{@base_url}/#{engine}/markets/#{market}/boards/#{board}/securities/#{ticker}/candles.json"

    params = [
      from: Date.to_iso8601(from),
      till: Date.to_iso8601(till),
      interval: interval
    ]

    fetch_all(url, params, [])
  end

  @doc """
  Parses a MOEX ISS candles JSON response body into a list of candle maps.
  """
  def parse(body) when is_binary(body) do
    with {:ok, data} <- Jason.decode(body) do
      {:ok, parse_data(data)}
    end
  end

  def parse(data) when is_map(data) do
    {:ok, parse_data(data)}
  end

  defp fetch_all(url, params, acc) do
    query = URI.encode_query(params)
    full_url = "#{url}?#{query}"

    case HTTPoison.get(full_url) do
      {:ok, %{status_code: 200, body: body}} ->
        with {:ok, data} <- Jason.decode(body) do
          candles = parse_data(data)
          merged = acc ++ candles

          case cursor(data) do
            {index, total, page_size} when index + page_size < total ->
              fetch_all(url, Keyword.put(params, :start, index + page_size), merged)

            _ ->
              {:ok, merged}
          end
        else
          error ->
            Logger.error("#{__MODULE__}: decode error #{inspect(error)}")
            {:error, :decode_error}
        end

      {:ok, %{status_code: status}} ->
        {:error, {:http_error, status}}

      {:error, reason} ->
        Logger.error("#{__MODULE__}: request error #{inspect(reason)}")
        {:error, reason}
    end
  end

  defp cursor(data) do
    case data["candles.cursor"] do
      %{"data" => [[index, total, page_size | _]]} ->
        {index, total, page_size}

      _ ->
        nil
    end
  end

  defp parse_data(data) do
    case data["candles"] do
      %{"columns" => columns, "data" => rows} ->
        Enum.map(rows, &row_to_candle(columns, &1))

      _ ->
        []
    end
  end

  defp row_to_candle(columns, row) do
    record = Enum.zip(columns, row) |> Map.new()

    {:ok, dt, _} = DateTime.from_iso8601(String.replace(record["begin"], " ", "T") <> "Z")

    %{
      open: record["open"],
      high: record["high"],
      low: record["low"],
      close: record["close"],
      volume: record["volume"],
      time: DateTime.to_unix(dt)
    }
  end
end
