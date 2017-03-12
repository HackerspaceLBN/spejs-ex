defmodule Spejs.Api.Notifications do
  alias Spejs.Accounts
  alias Spejs.Accounts.{User, Device}
  alias Spejs.Web.Endpoint

  use Bitwise, only_operators: true

  def at_hackerspace do
    devices = Accounts.list_devices_by(%{flag: 2})
    guests = devices
        |> Enum.filter(fn(device) -> is_nil(device.user_id) end)
    users = devices
        |> Enum.filter(&at_hackerspace?/1)
        |> Enum.map(fn(device) -> device.user end)
        |> Enum.uniq_by(fn(user) -> user.nickname end)

    %{
      guests: Enum.count(guests),
      active: Enum.map(users, & Map.take(&1, [:nickname, :name]))
    }
  end

  def device_flag_changed({:ok, %Device{} = device} = result) do
    user_data = %{nickname: device.user.nickname, device: device.name}
    # TODO : need check if user is already at hackerspace
    if at_hackerspace?(device) do
      broadcast_payload(case device.flag &&& 2 do
        2 -> %{joined: user_data}
        0 -> %{left: user_data}
      end)
    end

    result
  end
  def device_flag_changed(result), do: result

  def at_hackerspace?(%Device{user: user}), do: at_hackerspace?(user)
  def at_hackerspace?(%User{type: type}), do: Enum.member?(User.public_types, type)
  def at_hackerspace?(_), do: false

  defp broadcast_payload(payoad) do
    Endpoint.broadcast "device:notifications", "notification", %{data: payoad}
  end
end
