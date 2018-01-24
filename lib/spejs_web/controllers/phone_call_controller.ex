defmodule SpejsWeb.PhoneCallController do
  use SpejsWeb, :controller

  alias Spejs.Telecom
  alias Spejs.Telecom.PhoneCall

  action_fallback SpejsWeb.FallbackController

  def index(conn, _params) do
    phone_calls = Telecom.list_phone_calls()
    render(conn, "index.json", phone_calls: phone_calls)
  end

  def create(conn, %{"phone_call" => phone_call_params}) do
    with {:ok, %PhoneCall{} = phone_call} <- Telecom.create_phone_call(phone_call_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", phone_call_path(conn, :show, phone_call))
      |> render("show.json", phone_call: phone_call)
    end
  end

  def show(conn, %{"id" => id}) do
    phone_call = Telecom.get_phone_call!(id)
    render(conn, "show.json", phone_call: phone_call)
  end

  def update(conn, %{"id" => id, "phone_call" => phone_call_params}) do
    phone_call = Telecom.get_phone_call!(id)

    with {:ok, %PhoneCall{} = phone_call} <- Telecom.update_phone_call(phone_call, phone_call_params) do
      render(conn, "show.json", phone_call: phone_call)
    end
  end

  def delete(conn, %{"id" => id}) do
    phone_call = Telecom.get_phone_call!(id)
    with {:ok, %PhoneCall{}} <- Telecom.delete_phone_call(phone_call) do
      send_resp(conn, :no_content, "")
    end
  end
end
