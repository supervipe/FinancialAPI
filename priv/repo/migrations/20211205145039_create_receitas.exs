defmodule FinancialApp.Repo.Migrations.CreateReceitas do
  use Ecto.Migration

  def change do
    create table(:receitas) do
      add :name, :string
      add :valor, :float
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:receitas, [:user_id])
  end
end
