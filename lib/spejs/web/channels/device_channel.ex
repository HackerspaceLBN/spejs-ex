defmodule Spejs.Web.Channel.DeviceChannel do
  use Phoenix.Channel

  def join("device:notification", %{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "user_token", token,
                              max_age: 10000) do
      {:error, reason} -> {:error, %{reason: "unauthorized"}}
      {:ok, _} -> {:ok, socket}
    end
  end

  def join("device:" <> topic, _, socket) do
    {:error, %{reason: "unauthorized " <> topic}, socket}
  end

  def handle_out("device:connected", params, socket) do
    IO.inspect params, label: "======= params device:connected"
    {:noreply, socket}
  end

  def handle_out("device:disconnected", params, socket) do
    IO.inspect params, label: "======= params device:disconnected"
    {:noreply, socket}
  end

  def handle_in("device:connected", params, socket) do
    IO.inspect params, label: "======= params device:connected"
    {:noreply, socket}
  end

  def handle_in("device:disconnected", params, socket) do
    IO.inspect params, label: "======= params device:disconnected"
    {:noreply, socket}
  end
end
