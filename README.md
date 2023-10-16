# ExMoexLive

# Проект изучения структуры данных MOEX

Проект на базе Elixir. Для работы нужны erlang 24.3.1, elixir 1.15.7, docker + docker_compose для запуска БД PostgreSQL

# Прогресс разработки

Хочу разобраться, как делать интерфейсы на phoenix framework. 

Из moex пока скачиваются справочники engines, markets, boards, boardgroups, durations, securitytypes, securitygroups, securitycollections

# Контейнеры с pg и pg_admin
Для настройки окружения, можно запустить контейнеры с БД и с ПГ админом в отдельной консоли

```
sudo docker compose up
```

Или запустить, как демоны их

```
sudo docker compose up -d
```

# Сборка приложения

```
mix deps.get

```

# Создание БД для работы
Выполняется разово
```
mix ecto.create
mix ecto.migrate
```

# запуск приложения
```
iex -S mix phx.server 
```
В консоли - команда чтобы импортировать справочники

```
iex(3)> ExMoex.MOEX.Index.import
```
После этого можно сходить в локальный http://localhost/browser/ pg_admin  юзер `user@domain.com` пароль `SuperSecret` (см docker-compose.yml) и поделать sql запросы в бд localhost:ex_moex_dev

# Links

https://habr.com/ru/articles/759922/

https://fs.moex.com/files/6523

https://iss.moex.com/iss/index.json

https://github.com/UA3MQJ/elx-tables


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


# also

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
