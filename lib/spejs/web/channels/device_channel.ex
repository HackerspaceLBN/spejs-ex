defmodule Spejs.Web.Channel.DeviceChannel do
  use Phoenix.Channel

  def join("device:notifications", _, socket) do
    {:ok, socket}
  end

  def handle_in("ack", %{}, socket) do
    {:reply, {:ok, %{}}, socket}
  end

  def handle_in("notification", _, socket) do
    {:noreply, socket}
  end

  def handle_out("notification", _, socket) do
    {:noreply, socket}
  end
end
