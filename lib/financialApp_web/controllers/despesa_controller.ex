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
    changeset = Despesa.changeset(%Despesa{user_id: id}, despesa)

    case Repo.insert(changeset) do
      {:ok, _despesa} ->
        conn
       |> redirect(to: Routes.despesa_path(conn, :index, id))

      {:error, changeset} ->
        render(conn, "add_despesa.html", changeset: changeset, user_id: id)
    end
  end

  def edit(conn, %{"id" => id}) do
    despesa = Repo.get(Despesa, id)
    changeset = Despesa.changeset(despesa, %{})
    render(conn, "edit_despesa.html", despesa: despesa, changeset: changeset)
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
