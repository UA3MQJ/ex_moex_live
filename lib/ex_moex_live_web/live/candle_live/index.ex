defmodule ExMoexLiveWeb.CandleLive.Index do
  use ExMoexLiveWeb, :live_view

  alias ExMoexLive.Boards
  alias ExMoexLive.Indicators
  alias ExMoexLive.MOEX.Candles

  @intervals [
    {"1 minute", 1},
    {"10 minutes", 10},
    {"1 hour", 60},
    {"1 day", 24},
    {"1 week", 7}
  ]

  @impl true
  def mount(_params, _session, socket) do
    boards = Boards.list_candle_boards()
    default_board = Enum.find(boards, &(&1.boardid == "TQBR")) || List.first(boards)
    today = Date.utc_today()
    from = Date.add(today, -90)

    {:ok,
     socket
     |> assign(:boards, boards)
     |> assign(:intervals, @intervals)
     |> assign(:form, default_form(default_board, today, from))
     |> assign(:chart_data, nil)
     |> assign(:loading, false)
     |> assign(:error, if(boards == [], do: "Import MOEX directories first: ExMoexLive.MOEX.Index.import()", else: nil)), layout: {ExMoexLiveWeb.Layouts, :wide}}
  end

  @impl true
  def handle_event("load", %{"candle" => params}, socket) do
    socket = assign(socket, loading: true, error: nil)

    with {:ok, board} <- fetch_board(params["board_id"]),
         {:ok, ticker} <- parse_ticker(params["ticker"]),
         {:ok, from} <- parse_date(params["from"]),
         {:ok, till} <- parse_date(params["till"]),
         {:ok, interval} <- parse_interval(params["interval"]),
         {:ok, {engine, market, boardid}} <- {:ok, Boards.candle_path(board)},
         {:ok, candles} <-
           Candles.fetch(engine, market, boardid, ticker,
             from: from,
             till: till,
             interval: interval
           ) do
      if candles == [] do
        {:noreply,
         socket
         |> assign(:loading, false)
         |> assign(:chart_data, nil)
         |> assign(:error, "No candles returned for this ticker and date range")}
      else
        chart_data = Indicators.enrich(candles)

        {:noreply,
         socket
         |> assign(:form, params)
         |> assign(:chart_data, chart_data)
         |> assign(:loading, false)
         |> assign(:error, nil)
         |> push_event("chart-data", chart_data)}
      end
    else
      {:error, reason} ->
        {:noreply,
         socket
         |> assign(:loading, false)
         |> assign(:chart_data, nil)
         |> assign(:error, format_error(reason))}
    end
  end

  defp default_form(nil, today, from) do
    %{
      "board_id" => "",
      "ticker" => "SBER",
      "interval" => "24",
      "from" => Date.to_iso8601(from),
      "till" => Date.to_iso8601(today)
    }
  end

  defp default_form(board, today, from) do
    %{
      "board_id" => to_string(board.id),
      "ticker" => "SBER",
      "interval" => "24",
      "from" => Date.to_iso8601(from),
      "till" => Date.to_iso8601(today)
    }
  end

  defp fetch_board(id) when is_binary(id) do
    {:ok, Boards.get_board!(id)}
  rescue
    Ecto.NoResultsError -> {:error, :invalid_board}
  end

  defp parse_ticker(ticker) when is_binary(ticker) do
    trimmed = String.trim(ticker) |> String.upcase()

    if trimmed == "" do
      {:error, :invalid_ticker}
    else
      {:ok, trimmed}
    end
  end

  defp parse_date(date) when is_binary(date) do
    case Date.from_iso8601(date) do
      {:ok, parsed} -> {:ok, parsed}
      _ -> {:error, :invalid_date}
    end
  end

  defp parse_interval(interval) when is_binary(interval) do
    case Integer.parse(interval) do
      {value, ""} -> {:ok, value}
      _ -> {:error, :invalid_interval}
    end
  end

  defp format_error(:invalid_board), do: "Selected board was not found"
  defp format_error(:invalid_ticker), do: "Enter a ticker symbol"
  defp format_error(:invalid_date), do: "Invalid date format"
  defp format_error(:invalid_interval), do: "Invalid interval"
  defp format_error({:http_error, status}), do: "MOEX API returned HTTP #{status}"
  defp format_error(reason) when is_atom(reason), do: "Failed to load candles: #{reason}"
  defp format_error(reason), do: "Failed to load candles: #{inspect(reason)}"
end
