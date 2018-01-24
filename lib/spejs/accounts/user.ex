defmodule Spejs.Accounts.User do
  use SpejsWeb, :model
  use Coherence.Schema

  def user_types, do: ~w(user virtual project)
  def public_types, do: ~w(user)

  schema "accounts_users" do
    field :name, :string
    field :nickname, :string
    field :email, :string
    field :type, :string
    # has_many :devices, Accounts.Device

    coherence_schema()
    timestamps()
  end
end
