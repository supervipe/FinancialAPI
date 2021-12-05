defmodule FinancialApp.Despesa do
  use Ecto.Schema
  import Ecto.Changeset

  schema "despesas" do
    field :name, :string
    field :valor, :float
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(despesa, attrs) do
    despesa
    |> cast(attrs, [:name, :valor, :user_id])
    |> validate_required([:name, :valor, :user_id])
  end
end
