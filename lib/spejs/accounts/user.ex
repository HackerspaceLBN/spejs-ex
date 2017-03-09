defmodule Spejs.Accounts.User do
  use Spejs.Web, :model
  use Coherence.Schema

  def user_types, do: ~w(user virtual project)

  schema "accounts_users" do
    field :name, :string
    field :nickname, :string
    field :email, :string
    field :type, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    has_many :devices, Accounts.Device

    timestamps()
  end
end
