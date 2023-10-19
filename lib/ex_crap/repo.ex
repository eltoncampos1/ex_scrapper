defmodule Core.Repo do
  use Ecto.Repo,
    otp_app: :ex_crap,
    adapter: Ecto.Adapters.Postgres
end
