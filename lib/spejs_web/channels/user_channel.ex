defmodule SpejsWeb.Channel.UserChannel do
  use Phoenix.Channel

  def join("user:notification", _, socket) do
    {:ok, socket}
  end
  def join("user:" <> topic, _, socket) do
    {:error, %{reason: "unauthorized " <> topic}, socket}
  end

  intercept ["user:joined", "user:left"]

  def handle_out("user:joined", _, socket) do
    {:noreply, socket}
  end

  def handle_out("user:left", _, socket) do
    {:noreply, socket}
  end

  def handle_in("user:joined", _, socket) do
    {:noreply, socket}
  end

  def handle_in("user:left", _, socket) do
    {:noreply, socket}
  end

end
