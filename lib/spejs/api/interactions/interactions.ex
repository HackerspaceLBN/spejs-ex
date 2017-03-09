defmodule Spejs.Api.Interactions do
  alias Spejs.Accounts

  def at_hackerspace do
    devices = Accounts.list_devices_by(%{flag: 2})
    guests = devices
        |> Enum.filter(fn(device) -> is_nil(device.user_id) end)
    users = devices
        |> Enum.filter(fn(device) -> not is_nil(device.user_id) and device.user.type == "user" end)
        |> Enum.map(fn(device) -> device.user end)
        |> Enum.uniq_by(fn(user) -> user.nickname end)

    %{
      guests: Enum.count(guests),
      active: Enum.map(users, & Map.take(&1, [:nickname, :name]))
    }
  end

  def update_devices(devices) do
    devices
      |> Enum.filter(&(&1 != %{}))
      |> Enum.map(&update_params/1)
      |> process
  end

  defp process(params) do
    with devices <- Accounts.list_devices_by(%{mac_list: Enum.map(params, & &1.mac)}),
      device_mac_list <- Enum.map(devices, & &1.mac),
      update_params <- Enum.filter(params, fn(p) ->     p.mac in device_mac_list end),
      create_params <- Enum.filter(params, fn(p) -> not p.mac in device_mac_list end)
      do
        result = update_stream(devices, update_params) ++ insert_stream(create_params)

        %{
          updates: Enum.filter(result, fn({status, _}) -> status == :ok end),
          errors: Enum.filter(result, fn({status, _}) -> status != :ok end)
        }
      end
  end

  defp update_stream(devices, update_params) do
    # TODO: make it bulk changes like Repo.update_all compatible
    Enum.map(devices, fn(device) ->
      changes = Enum.find(update_params, fn(param) -> param.mac == device.mac end)
      if changes.flag != device.flag, do: Accounts.update_device(device, changes)
    end)
      |> Enum.filter(&(not is_nil(&1)))
  end

  defp insert_stream(device_params) do
    # TODO: make it bulk changes Repo.insert_all compatible
    Enum.map(device_params, & Accounts.create_device(&1))
  end

  defp update_params(params) do
    # TODO: filter out params without necessary keys
    with device_params <- atomize_shallow(params),
      do: %{device_params | flag: parse_integer(device_params.flag)}
  end

  def atomize_shallow(%{} = map) do
    map
    |> Enum.map(fn {key, value} -> {String.to_atom(key), value} end)
    |> Enum.into(%{})
  end

  def parse_integer("0x" <> string) do
    # Take take only integer part of parsing
    elem(case string do
      "0x" <> hex_string -> Integer.parse(hex_string)
      other -> Integer.parse(other)
    end, 0)
  end
end
