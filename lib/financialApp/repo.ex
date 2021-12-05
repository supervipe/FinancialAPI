defmodule FinancialApp.Repo do
  use Ecto.Repo,
    otp_app: :financialApp,
    adapter: Ecto.Adapters.Postgres
end
