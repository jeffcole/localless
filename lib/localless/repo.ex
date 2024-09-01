defmodule Localless.Repo do
  use Ecto.Repo,
    otp_app: :localless,
    adapter: Ecto.Adapters.Postgres
end
