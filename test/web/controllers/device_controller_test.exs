defmodule Spejs.Web.DeviceControllerTest do
  use Spejs.Web.ConnCase, async: true

  alias Spejs.Accounts

  @create_attrs %{mac: "mac-1", name: "some name"}
  @update_attrs %{mac: "mac-2", name: "some updated name"}
  @invalid_attrs %{mac: '', name: ''}

  def fixture(:device) do
    {:ok, device} = Accounts.create_device(@create_attrs)
    device
  end

  setup %{conn: conn} = params do
    params |> login_user
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, device_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Devices"
  end

  test "renders form for new devices", %{conn: conn} do
    conn = get conn, device_path(conn, :new)
    assert html_response(conn, 200) =~ "New Device"
  end

  test "creates device and and display flash message", %{conn: conn} do
    conn = post conn, device_path(conn, :create), device: @create_attrs
    
    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == device_path(conn, :show, id)
    
    conn = get conn, device_path(conn, :show, id)
    assert get_flash(conn, :info) =~ "Device created successfully."
  end

  test "does not create device and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, device_path(conn, :create), device: @invalid_attrs
    assert html_response(conn, 200) =~ "New Device"
  end

  test "renders form for editing chosen device", %{conn: conn} do
    device = fixture(:device)
    conn = get conn, device_path(conn, :edit, device)
    assert html_response(conn, 200) =~ "Edit Device"
  end

  test "updates chosen device and and display flash message", %{conn: conn} do
    device = fixture(:device)
    conn = put conn, device_path(conn, :update, device), device: @update_attrs
    assert redirected_to(conn) == device_path(conn, :show, device)
    
    conn = get conn, device_path(conn, :show, device)
    assert get_flash(conn, :info) =~ "Device updated successfully."
  end

  test "does not update chosen device and renders errors when data is invalid", %{conn: conn} do
    device = fixture(:device)
    conn = put conn, device_path(conn, :update, device), device: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Device"
  end

  test "deletes chosen device and display flash message", %{conn: conn} do
    device = fixture(:device)
    conn = delete conn, device_path(conn, :delete, device)

    assert get_flash(conn, :info) =~ "Device deleted successfully."
  end
end
