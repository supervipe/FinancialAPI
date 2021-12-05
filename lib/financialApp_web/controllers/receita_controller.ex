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
    render(conn, "index.html.heex", receitas: receitas, user_id: id)
  end
  def show(conn, %{"id" => id}) do
    receita = Repo.get(Receita, String.to_integer(id))
    render(conn, "index.html.heex", receita: receita)
  end

  def new(conn, %{"id" => id}) do
    changeset = Receita.changeset(%Receita{}, %{})
    render(conn, "index.html.heex", changeset: changeset, user_id: id)
  end

  def create(conn, %{"id" => id, "receita" => receita}) do
    inteiro = String.to_integer(id)
    changeset = Receita.changeset(%Receita{user_id: inteiro}, receita)
    case Repo.insert(changeset) do
      {:ok, ^receita} ->
        conn
        |> put_flash(:info, "Receita criada com sucesso!")
        |> redirect(to: Routes.receita_path(conn, :show, id))
      {":error", changeset} ->
        render(conn, "html", changeset: changeset, user_id: id)
    end
  end

  def edit(conn, %{"id" => id}) do
    receita = Repo.get(Receita, id)
    changeset = Receita.changeset(receita, %{})
    render(conn, "index.html.heex", receita: receita, changeset: changeset)
  end

  def update(conn, %{"id" => id, "receita" => receita}) do
    r = Repo.get(Receita, id)
    changeset = Receita.changeset(r, receita)
    {:ok, ^receita} = Repo.update(changeset)

    conn
    |> put_flash(:info, "Receita alterada com sucesso!")
    |> redirect(to: Routes.receita_path(conn, :show, r.user_id))

  end

  def delete(conn, %{"id" => id}) do
    receita = Repo.get(Receita, id)
    {:ok, receita} = Repo.delete(receita)

    conn
    |> put_flash(:info, "Receita deletada com sucesso!")
    |> redirect(to: Routes.receita_path(conn, :show, receita.user_id))

  end

end
