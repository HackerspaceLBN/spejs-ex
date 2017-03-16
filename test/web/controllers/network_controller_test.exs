defmodule Spejs.Web.NetworkControllerTest do
  use Spejs.Web.ConnCase

  alias Spejs.Accounts

  @create_attrs %{address: "some address", mask: "some mask", name: "some name"}
  @update_attrs %{address: "some updated address", mask: "some updated mask", name: "some updated name"}
  @invalid_attrs %{address: nil, mask: nil, name: nil}

  def fixture(:network) do
    {:ok, network} = Accounts.create_network(@create_attrs)
    network
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, network_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Networks"
  end

  test "renders form for new networks", %{conn: conn} do
    conn = get conn, network_path(conn, :new)
    assert html_response(conn, 200) =~ "New Network"
  end

  test "creates network and redirects to show when data is valid", %{conn: conn} do
    conn = post conn, network_path(conn, :create), network: @create_attrs

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == network_path(conn, :show, id)

    conn = get conn, network_path(conn, :show, id)
    assert html_response(conn, 200) =~ "Show Network"
  end

  test "does not create network and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, network_path(conn, :create), network: @invalid_attrs
    assert html_response(conn, 200) =~ "New Network"
  end

  test "renders form for editing chosen network", %{conn: conn} do
    network = fixture(:network)
    conn = get conn, network_path(conn, :edit, network)
    assert html_response(conn, 200) =~ "Edit Network"
  end

  test "updates chosen network and redirects when data is valid", %{conn: conn} do
    network = fixture(:network)
    conn = put conn, network_path(conn, :update, network), network: @update_attrs
    assert redirected_to(conn) == network_path(conn, :show, network)

    conn = get conn, network_path(conn, :show, network)
    assert html_response(conn, 200) =~ "some updated address"
  end

  test "does not update chosen network and renders errors when data is invalid", %{conn: conn} do
    network = fixture(:network)
    conn = put conn, network_path(conn, :update, network), network: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Network"
  end

  test "deletes chosen network", %{conn: conn} do
    network = fixture(:network)
    conn = delete conn, network_path(conn, :delete, network)
    assert redirected_to(conn) == network_path(conn, :index)
    assert_error_sent 404, fn ->
      get conn, network_path(conn, :show, network)
    end
  end
end
