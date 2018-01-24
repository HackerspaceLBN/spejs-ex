defmodule SpejsWeb.Channel.DeviceChannel do
  use Phoenix.Channel
  alias Spejs.Accounts.Device

  def join("device:notification", %{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "user_token", token,
                              max_age: 10_000) do
      {:error, reason} -> {:error, %{reason: reason}}
      {:ok, _} -> {:ok, socket}
    end
  end

  def join("device:" <> topic, _, socket) do
    {:error, %{reason: "unauthorized " <> topic}, socket}
  end

  intercept ["device:connected", "device:disconnected", "device:idle"]

  def handle_out("device:connected" = action, %Device{} = device, socket) do
    push socket, action, %{
      connected: Map.take(device, [:name, :flag, :ip])
    }
    {:noreply, socket}
  end

  def handle_out("device:disconnected" = action, %Device{} = device, socket) do
    push socket, action, %{
      disconnected: Map.take(device, [:name, :flag, :ip])
    }
    {:noreply, socket}
  end

  def handle_out("device:idle" = action, %Device{} = device, socket) do
    push socket, action, %{
      idle: Map.take(device, [:name, :flag, :ip])
    }
    {:noreply, socket}
  end
end
