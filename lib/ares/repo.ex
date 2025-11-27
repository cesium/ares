defmodule Ares.Repo do
  use Ecto.Repo,
    otp_app: :ares,
    adapter: Ecto.Adapters.Postgres
end
