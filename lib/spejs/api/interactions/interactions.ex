defmodule Spejs.Api.Interactions do
  alias Spejs.Accounts
  alias Spejs.Accounts.Device

  def at_hackerspace do
    devices = Accounts.list_devices_by(%{flag: 2})

    %{
      guests: Enum.filter(devices, fn(device) -> is_nil(device.user_id) end)
        |> Enum.count,
      active: Enum.filter(devices, fn(device) -> not is_nil(device.user_id) and device.user.type == "user" end)
        |> Enum.map(fn(device) -> %{nickname: device.user.nickname, name: device.user.name} end)
        |> Enum.uniq_by(fn (nickname) -> nickname end)
    }
  end

  def update_devices(data) do
     with status <- process_devices(data),
      do: {:ok, status}
  end

  defp process_devices(devices) do
    devices
      |> Enum.map(&update_params/1)
      |> Enum.map(&process_device/1)
      |> Enum.filter(fn(device) -> not is_nil(device) end)
  end

  defp update_params(params) when params != %{} do
    with device_params <- map_keys_to_atoms(params),
      do: %{device_params | flag: parse_integer(device_params.flag)}
  end
  defp update_params(params), do: params

  defp process_device(device_data) when device_data != %{} do
    case Accounts.get_device_by(device_data) do
      nil ->
        case Accounts.create_device(device_data) do
          {:ok, device} -> device
          {:error, _} -> nil
        end
      device ->
        if device.flag !== device_data.flag do
          case Accounts.update_device(device, device_data) do
            {:ok, device} -> device
            {:error, _} -> nil
          end
        end
    end
  end
  defp process_device(_), do: nil

  def map_keys_to_atoms(map) do
    for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}
  end

  def parse_integer("0x" <> string) do
    {val, ""} = case string do
      "0x" <> hex_string -> Integer.parse(hex_string)
      other -> Integer.parse(other)
    end

    val
  end
end
