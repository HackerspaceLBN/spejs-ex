defmodule Spejs.Web.Channel.DeviceChannel do
  use Phoenix.Channel

  def join("device:notification", %{"token" => token}, socket) do
    case result = Phoenix.Token.verify(socket, "user_token", token,
                              max_age: 10000) do
      {:error, reason} ->
        IO.inspect reason, label: "======= error"
        {:error, %{reason: "unauthorized"}}
      {:ok, token} ->
        IO.inspect token, label: "======= join"
        {:ok, socket}
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
