defmodule Spejs.Web.PhoneCallControllerTest do
  use Spejs.Web.ConnCase

  alias Spejs.Telecom
  alias Spejs.Telecom.PhoneCall

  @create_attrs %{destination: "some destination", source: "some source", stop_at: ~N[2010-04-17 14:00:00.000000]}
  @update_attrs %{destination: "some updated destination", source: "some updated source", stop_at: ~N[2011-05-18 15:01:01.000000]}
  @invalid_attrs %{destination: nil, source: nil, stop_at: nil}

  def fixture(:phone_call) do
    {:ok, phone_call} = Telecom.create_phone_call(@create_attrs)
    phone_call
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, phone_call_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates phone_call and renders phone_call when data is valid", %{conn: conn} do
    conn = post conn, phone_call_path(conn, :create), phone_call: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, phone_call_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "destination" => "some destination",
      "source" => "some source",
      "stop_at" => ~N[2010-04-17 14:00:00.000000]}
  end

  test "does not create phone_call and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, phone_call_path(conn, :create), phone_call: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen phone_call and renders phone_call when data is valid", %{conn: conn} do
    %PhoneCall{id: id} = phone_call = fixture(:phone_call)
    conn = put conn, phone_call_path(conn, :update, phone_call), phone_call: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, phone_call_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "destination" => "some updated destination",
      "source" => "some updated source",
      "stop_at" => ~N[2011-05-18 15:01:01.000000]}
  end

  test "does not update chosen phone_call and renders errors when data is invalid", %{conn: conn} do
    phone_call = fixture(:phone_call)
    conn = put conn, phone_call_path(conn, :update, phone_call), phone_call: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen phone_call", %{conn: conn} do
    phone_call = fixture(:phone_call)
    conn = delete conn, phone_call_path(conn, :delete, phone_call)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, phone_call_path(conn, :show, phone_call)
    end
  end
end
