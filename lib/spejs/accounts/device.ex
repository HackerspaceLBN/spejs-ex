defmodule Spejs.Accounts.Device do
  use Spejs.Web, :model

  schema "accounts_devices" do
    field :name, :string
    field :mac, :string
    field :ip, :string
    field :flag, :integer

    belongs_to :user, Spejs.Accounts.User

    timestamps()
  end
end
