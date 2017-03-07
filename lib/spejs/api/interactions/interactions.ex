defmodule Spejs.Api.Interactions do
  alias Spejs.Accounts
  alias Spejs.Accounts.Device

  def update_devices(data) do
     with status <- process_devices(data),
      do: {:ok, status}
  end

  defp process_devices(devices) do
    devices
      |> Enum.map(&(update_params(&1)))
      |> Enum.map(&(process_device(&1)))
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
          {:error, _} -> %Device{}
        end
      device ->
        case Accounts.update_device(device, device_data) do
          {:ok, device} -> device
          {:error, _} -> %Device{}
        end
    end
  end
  defp process_device(_device_data), do: %Device{}

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
