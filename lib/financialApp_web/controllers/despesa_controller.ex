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
    render(conn, "list_despesas.html", despesas: despesas, user_id: id)
  end

  def show(conn, %{"id" => id}) do
    despesa = Repo.get(Despesa, String.to_integer(id))
    render(conn, "list_despesas.html", despesa: despesa)
  end

  def new(conn, %{"id" => id}) do
    changeset = Despesa.changeset(%Despesa{}, %{})
    render(conn, "add_despesa.html", changeset: changeset, user_id: id)
  end

  def create(conn, %{"id" => id, "despesa" => despesa}) do
    inteiro = String.to_integer(id)
    changeset = Despesa.changeset(%Despesa{user_id: inteiro}, despesa)
    {:ok, _despesa} = Repo.insert(changeset)

    conn
    |> put_flash(:info, "Despesa criada com sucesso!")
    |> redirect(to: Routes.despesa_path(conn, :index, id))
  end

  def edit(conn, %{"id" => id}) do
    inteiro = String.to_integer(id)
    despesa = Repo.get(Despesa, inteiro)
    changeset = Despesa.changeset(despesa, %{})
    render(conn, "edit_despesa.html", despesa_id: despesa.id, changeset: changeset)
  end

  def update(conn, %{"id" => id, "despesa" => despesa}) do
    des = Repo.get(Despesa, id)
    changeset = Despesa.changeset(des, despesa)
    {:ok, _despesa} = Repo.update(changeset)

    conn
    |> put_flash(:info, "Despesa alterada com sucesso!")
    |> redirect(to: Routes.despesa_path(conn, :index, des.user_id))
  end

  def delete(conn, %{"id" => id}) do
    despesa = Repo.get(Despesa, id)
    {:ok, despesa} = Repo.delete(despesa)

    conn
    |> put_flash(:info, "Despesa deletada com sucesso!")
    |> redirect(to: Routes.despesa_path(conn, :index, despesa.user_id))

  end

end
