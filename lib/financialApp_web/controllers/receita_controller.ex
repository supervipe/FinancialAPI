defmodule FinancialAppWeb.ReceitaController do
  use FinancialAppWeb, :controller
  alias FinancialApp.Receita
  alias FinancialApp.Repo
  import Ecto.Query

  def index(conn,  %{"id" => id}) do
    receitas =
      Repo.all(
        from r in Receita, select: [r.name, r.valor, r.id], where: r.user_id == ^id
      )
    render(conn, "list_receita.html", receitas: receitas, user_id: id)
  end

  def new(conn, %{"id" => id}) do
    changeset = Receita.changeset(%Receita{}, %{})
    render(conn, "add_receita.html", changeset: changeset, user_id: id)
  end

  def create(conn, %{"id" => id, "receita" => receita}) do
    inteiro = String.to_integer(id)
    changeset = Receita.changeset(%Receita{user_id: inteiro}, receita)
    {:ok, _receita} = Repo.insert(changeset)

    conn
    |> put_flash(:info, "Receita criada com sucesso!")
    |> redirect(to: Routes.receita_path(conn, :index, id))
  end

  def edit(conn, %{"id" => id}) do
    inteiro = String.to_integer(id)
    receita = Repo.get(Receita, inteiro)
    changeset = Receita.changeset(receita, %{})
    render(conn, "edit_receita.html", receita_id: receita.id, changeset: changeset)
  end

  def update(conn, %{"id" => id, "receita" => receita}) do
    r = Repo.get(Receita, id)
    changeset = Receita.changeset(r, receita)
    {:ok, _receita} = Repo.update(changeset)

    conn
    |> put_flash(:info, "Receita alterada com sucesso!")
    |> redirect(to: Routes.receita_path(conn, :index, r.user_id))

  end

  def delete(conn, %{"id" => id}) do
    receita = Repo.get(Receita, id)
    {:ok, receita} = Repo.delete(receita)

    conn
    |> put_flash(:info, "Receita deletada com sucesso!")
    |> redirect(to: Routes.receita_path(conn, :index, receita.user_id))

  end

end
