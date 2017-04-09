defmodule Spejs.Web.DeviceView do
  use Spejs.Web, :view

  def available_users do
    Spejs.Accounts.list_users
      |> Enum.map(&{&1.name, &1.id})
  end

  def available_networks do
    Spejs.Accounts.list_networks
      |> Enum.map(&{&1.name, &1.id})
  end

end
