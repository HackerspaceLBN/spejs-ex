defmodule Spejs.Web.InteractionsView do
  use Spejs.Web, :view

  def render("device_action.json", %{device: device}) do
    case device do
      nil ->
        %{}
      device ->
        %{
          name: device.name,
          identifier: device.identifier,
          id: device.id
        }
    end
  end

  def render("message.json", %{data: data}) do
    data
  end

end
