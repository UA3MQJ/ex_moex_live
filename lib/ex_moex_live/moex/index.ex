defmodule ExMoexLive.MOEX.Index do
  require Logger
  def get do
    url = "https://iss.moex.com/iss/index.json"

    data = with {:ok, response} <- HTTPoison.get(url),
        {:ok, data} <- Jason.decode(response.body) do

      data
    else
    error ->
      Logger.error("#{__MODULE__}: #{inspect(error)}")
      :error
    end

    data
  end

  def import do
    data = get()

    ExMoexLive.Engines.import(data["engines"])
    ExMoexLive.Markets.import(data["markets"])
    ExMoexLive.Boards.import(data["boards"])
    ExMoexLive.BoardGroups.import(data["boardgroups"])
    ExMoexLive.Durations.import(data["durations"])
    ExMoexLive.SecurityTypes.import(data["securitytypes"])
    ExMoexLive.SecurityGroups.import(data["securitygroups"])
    ExMoexLive.SecurityCollections.import(data["securitycollections"])
  end


end
