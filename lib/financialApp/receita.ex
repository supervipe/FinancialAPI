defmodule FinancialApp.Receita do
  use Ecto.Schema
  import Ecto.Changeset

  schema "receitas" do
    field :name, :string
    field :valor, :float
    field :user_id, :integer


    timestamps()
  end

  @doc false
  def changeset(receita, attrs) do
    receita
    |> cast(attrs, [:name, :valor, :user_id])
    |> validate_required([:name, :valor, :user_id])
  end
end
