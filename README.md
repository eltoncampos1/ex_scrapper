# ex_scrapper

## prerequisites
 - Elixir
 - Erlang
 - Docker

### nice to have
 - asdf

## Tools
 - Floki: HTML Parser
 - Finch: HTTP handler
 - Iconv: parse utf 8
 - scrivener_ecto: Pagination

To start your Phoenix server:

  * Run Docker to start the Database
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Basic routes
 - Create User
 `http://localhost:4000/users/register`

 - Login
 `http://localhost:4000/users/log_in`

 - Page scrapping
 `http://localhost:4000/dashboard`
