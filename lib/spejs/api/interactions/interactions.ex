defmodule Spejs.Api.Interactions do
  alias Spejs.Accounts
  alias Spejs.Api.Notifications
  alias Spejs.Utils

  def update_devices(devices) do
    devices
      |> Enum.filter(&(&1 != %{}))
      |> Enum.map(&update_params/1)
      |> process
  end

  defp process(params) do
    with {:ok, devices, update_params, create_params} <- prepare_process(params) do
        result = update_stream(devices, update_params) ++ insert_stream(create_params)

        result |> Enum.each(&Notifications.device_flag_changed/1)

        %{
          updates: Enum.filter(result, fn({status, _}) -> status == :ok end),
          errors: Enum.filter(result, fn({status, _}) -> status == :error end),
          ignores: Enum.filter(result, fn({status, _}) -> status == :idle end)
        }
      end
  end

  defp prepare_process(params) do
    devices = Accounts.list_devices_by(%{mac_list: Enum.map(params, & &1.mac)})
    device_mac_list = Enum.map(devices, & &1.mac)
    update_params = Enum.filter(params, fn(p) ->     p.mac in device_mac_list end)
    create_params = Enum.filter(params, fn(p) -> not p.mac in device_mac_list end)

    {:ok, devices, update_params, create_params}
  end

  defp update_stream(devices, update_params) do
    # TODO: make it bulk changes like Repo.update_all compatible
    devices
      |> Enum.map(fn(device) ->
      changes = Enum.find(update_params, fn(param) ->
        param.mac == device.mac
      end)

      if changes.flag != device.flag do
        Accounts.update_device(device, changes)
      else
        {:idle, device}
      end
    end)
      |> Enum.filter(&(not is_nil(&1)))
  end

  defp insert_stream(device_params) do
    # TODO: make it bulk changes Repo.insert_all compatible
    Enum.map(device_params, & Accounts.create_device(&1))
  end

  defp update_params(params) do
    # TODO: filter out params without necessary keys
    with device_params <- Utils.atomize_shallow(params),
      do: %{device_params | flag: Utils.parse_integer(device_params.flag)}
  end
end
