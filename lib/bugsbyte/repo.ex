defmodule Bugsbyte.Repo do
  use Ecto.Repo,
    otp_app: :bugsbyte,
    adapter: Ecto.Adapters.Postgres
end
