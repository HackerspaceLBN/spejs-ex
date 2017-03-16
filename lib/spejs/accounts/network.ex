defmodule Spejs.Accounts.Network do
  use Ecto.Schema

  schema "accounts_networks" do
    field :address, :string
    field :mask, :string
    field :name, :string

    timestamps()
  end
end
