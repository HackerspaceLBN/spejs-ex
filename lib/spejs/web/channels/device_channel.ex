defmodule Spejs.Web.Channel.DeviceChannel do
  use Phoenix.Channel

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

  def handle_out("device:connected", params, socket) do
    {:noreply, socket}
  end

  def handle_out("device:disconnected", params, socket) do
    {:noreply, socket}
  end

  def handle_in("device:connected", params, socket) do
    {:noreply, socket}
  end

  def handle_in("device:disconnected", params, socket) do
    {:noreply, socket}
  end
end
