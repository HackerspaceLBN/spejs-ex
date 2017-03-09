defmodule Spejs.Accounts.User do
  use Spejs.Web, :model

  def user_types, do: ~w(user virtual project)

  schema "accounts_users" do
    field :name, :string
    field :nickname, :string
    field :email, :string
    field :type, :string
    # has_many :devices, Accounts.Device

    timestamps()
  end
end
