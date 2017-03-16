defmodule Spejs.Web.NetworkController do
  use Spejs.Web, :controller

  alias Spejs.Accounts

  def index(conn, _params) do
    networks = Accounts.list_networks()
    render(conn, "index.html", networks: networks)
  end

  def new(conn, _params) do
    changeset = Accounts.change_network(%Spejs.Accounts.Network{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"network" => network_params}) do
    case Accounts.create_network(network_params) do
      {:ok, network} ->
        conn
        |> put_flash(:info, "Network created successfully.")
        |> redirect(to: network_path(conn, :show, network))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    network = Accounts.get_network!(id)
    render(conn, "show.html", network: network)
  end

  def edit(conn, %{"id" => id}) do
    network = Accounts.get_network!(id)
    changeset = Accounts.change_network(network)
    render(conn, "edit.html", network: network, changeset: changeset)
  end

  def update(conn, %{"id" => id, "network" => network_params}) do
    network = Accounts.get_network!(id)

    case Accounts.update_network(network, network_params) do
      {:ok, network} ->
        conn
        |> put_flash(:info, "Network updated successfully.")
        |> redirect(to: network_path(conn, :show, network))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", network: network, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    network = Accounts.get_network!(id)
    {:ok, _network} = Accounts.delete_network(network)

    conn
    |> put_flash(:info, "Network deleted successfully.")
    |> redirect(to: network_path(conn, :index))
  end
end
