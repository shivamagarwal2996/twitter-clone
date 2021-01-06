defmodule Exp.Repo do
  use Ecto.Repo,
    otp_app: :exp,
    adapter: Ecto.Adapters.Postgres
end
