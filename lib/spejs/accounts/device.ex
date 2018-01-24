defmodule Spejs.Accounts.Device do
  use SpejsWeb, :model

  schema "accounts_devices" do
    field :name, :string
    field :mac, :string
    field :ip, :string
    field :flag, :integer

    belongs_to :user, Spejs.Accounts.User
    belongs_to :network, Spejs.Accounts.Network

    timestamps()
  end
end
