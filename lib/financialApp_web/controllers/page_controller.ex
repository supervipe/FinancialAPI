defmodule FinancialAppWeb.PageController do
  use FinancialAppWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
