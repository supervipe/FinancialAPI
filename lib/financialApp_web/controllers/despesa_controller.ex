defmodule FinancialAppWeb.DespesaController do
  use FinancialAppWeb, :controller
  alias FinancialApp.Despesa
  alias FinancialApp.Repo
  import Ecto.Query

  def index(conn,  %{"id" => id}) do
    despesas =
      Repo.all(
        from d in Despesa, select: [d.name, d.valor, d.id], where: d.user_id == ^id
      )
    render(conn, "home.html", despesas: despesas, user_id: id)
  end
  def show(conn, %{"id" => id}) do
    despesa = Repo.get(Despesa, String.to_integer(id))
    render(conn, "home.html", despesa: despesa)
  end

  def new(conn, %{"id" => id}) do
    changeset = Despesa.changeset(%Despesa{}, %{})
    render(conn, "cadastro.html.heex", changeset: changeset, user_id: id)
  end

  def create(conn, %{"id" => id, "despesa" => despesa}) do
    changeset = Despesa.changeset(%Despesa{user_id: id}, despesa)
    {:ok, ^despesa} = Repo.insert(changeset)

    conn
    |> put_flash(:info, "Despesa criada com sucesso!")
    |> redirect(to: Routes.despesa_path(conn, :show, id))

  end

  def edit(conn, %{"id" => id}) do
    despesa = Repo.get(Despesa, id)
    changeset = Despesa.changeset(despesa, %{})
    render(conn, "cadastro.html.heex", despesa: despesa, changeset: changeset)
  end

  def update(conn, %{"id" => id, "despesa" => despesa}) do
    des = Repo.get(Despesa, id)
    changeset = Despesa.changeset(des, despesa)
    {:ok, ^despesa} = Repo.update(changeset)

    conn
    |> put_flash(:info, "Despesa alterada com sucesso!")
    |> redirect(to: Routes.despesa_path(conn, :show, des.user_id))

  end

  def delete(conn, %{"id" => id}) do
    despesa = Repo.get(Despesa, id)
    {:ok, despesa} = Repo.delete(despesa)

    conn
    |> put_flash(:info, "Despesa deletada com sucesso!")
    |> redirect(to: Routes.despesa_path(conn, :show, despesa.user_id))

  end

end
