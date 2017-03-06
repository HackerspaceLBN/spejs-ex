defmodule Spejs.Accounts.Device do
  use Ecto.Schema

  schema "accounts_devices" do
    field :name, :string
    field :identifier, :string
    belongs_to :user, Spejs.Accounts.User

    timestamps()
  end
end
