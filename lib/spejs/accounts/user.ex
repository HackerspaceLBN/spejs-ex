defmodule Spejs.Accounts.User do
  use Ecto.Schema

  schema "accounts_users" do
    field :name, :string
    field :nickname, :string
    field :email, :string

    timestamps()
  end
end
