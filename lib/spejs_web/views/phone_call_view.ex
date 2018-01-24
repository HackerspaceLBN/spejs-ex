defmodule SpejsWeb.PhoneCallView do
  use SpejsWeb, :view
  alias SpejsWeb.PhoneCallView

  def render("index.json", %{phone_calls: phone_calls}) do
    %{data: render_many(phone_calls, PhoneCallView, "phone_call.json")}
  end

  def render("show.json", %{phone_call: phone_call}) do
    %{data: render_one(phone_call, PhoneCallView, "phone_call.json")}
  end

  def render("phone_call.json", %{phone_call: phone_call}) do
    %{id: phone_call.id,
      source: phone_call.source,
      destination: phone_call.destination,
      start_at: phone_call.start_at,
      stop_at: phone_call.stop_at}
  end
end
