defmodule Spejs.Accounts.Device do
  use Ecto.Schema

  schema "accounts_devices" do
    field :name, :string
    field :mac, :string
    belongs_to :user, Spejs.Accounts.User

    field :ip, :string, virtual: true
    field :flag, :integer

    timestamps()
  end
end
