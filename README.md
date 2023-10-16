# ExMoexLive

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

# links
https://www.phoenixframework.org/blog/build-a-real-time-twitter-clone-in-15-minutes-with-live-view-and-phoenix-1-5

# ...

mix phx.new ex_moex_live --live

mix phx.gen.live Boards Board boards board_group_id:integer engine_id:integer market_id:integer boardid:string board_title:string is_traded:integer has_candles:integer is_primary:integer

mix phx.gen.live BoardGroups BoardGroup board_groups trade_engine_id:integer trade_engine_name:string trade_engine_title:string market_id:integer market_name:string name:string title:string is_default:integer board_group_id:integer is_traded:integer is_order_driven:integer category:string

mix phx.gen.live Durations Duration durations interval:integer duration:integer days:integer title:string hint:string

mix phx.gen.live Engines Engine engines name:string title:string

mix phx.gen.live Markets Market markets trade_engine_id:integer trade_engine_name:string trade_engine_title:string market_name:string market_title:string market_id:integer marketplace:string is_otc:integer has_history_files:integer has_history_trades_files:integer has_trades:integer has_history:integer has_candles:integer has_orderbook:integer has_tradingsession:integer has_extra_yields:integer has_delay:integer

mix phx.gen.live SecurityCollections SecurityCollection security_collections name:string title:string security_group_id:integer

mix phx.gen.live SecurityGroups SecurityGroup security_groups name:string title:string is_hidden:integer

mix phx.gen.live SecurityTypes SecurityType security_types trade_engine_id:integer trade_engine_name:string trade_engine_title:string security_type_name:string security_type_title:string security_group_name:string stock_type:string