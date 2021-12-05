defmodule FinancialApp.Repo.Migrations.CreateDespesas do
  use Ecto.Migration

  def change do
    create table(:despesas) do
      add :name, :string
      add :valor, :float
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:despesas, [:user_id])
  end
end
