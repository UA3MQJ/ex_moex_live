defmodule ExMoexLive.Repo do
  use EctoHooks.Repo,
    otp_app: :ex_moex_live,
    adapter: Ecto.Adapters.Postgres
end
