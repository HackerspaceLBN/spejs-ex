defmodule Spejs.Accounts.User do
  use Ecto.Schema

  schema "accounts_users" do
    field :name, :string
    field :nickname, :string
    field :email, :string
    # has_many :devices, Accounts.Device

    timestamps()
  end
end
