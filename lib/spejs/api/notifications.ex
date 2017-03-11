defmodule Spejs.Api.Notifications do
  alias Spejs.Accounts.{User, Device}
  alias Spejs.Web.Endpoint

  use Bitwise, only_operators: true

  def device_flag_changed({:ok, %Device{} = device} = result) do
    user_data = %{nickname: device.user.nickname, device: device.name}

    # TODO : need check if user is already at hackerspace
    broadcast_payload(case device.flag &&& 2 do
      2 -> %{joined: user_data}
      0 -> %{left: user_data}
    end)

    result
  end
  def device_flag_changed(result), do: result

  defp broadcast_payload(payoad) do
    Endpoint.broadcast "device:notifications", "notification", %{data: payoad}
  end
end
