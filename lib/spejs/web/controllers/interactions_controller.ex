defmodule Spejs.Web.InteractionsController do
  use Spejs.Web, :controller

  alias Spejs.Api.Notifications
  alias Spejs.Api.Interactions
  alias Spejs.Accounts

  def index(conn, _params) do
    [result | _] = Enum.take_random [
      "(╯°□°）╯︵ ┻━┻",
      "(┛◉Д◉)┛彡┻━┻",
      "(ﾉ≧∇≦)ﾉ ﾐ ┸━┸",
      "(ノಠ益ಠ)ノ彡┻━┻",
      "(╯ರ ~ ರ）╯︵ ┻━┻",
      "(┛ಸ_ಸ)┛彡┻━┻",
      "(ﾉ´･ω･)ﾉ ﾐ ┸━┸",
      "(ノಥ,_｣ಥ)ノ彡┻━┻",
      "(┛✧Д✧))┛彡┻━┻"
    ], 1
    json(conn,  result)
  end

  def sensors(conn, %{"data" => _data}) do
    try do
      json(conn, :ok)
    rescue
      exception ->
        Sentry.capture_exception(exception, [stacktrace: System.stacktrace()])
        json(conn, %{status: :failure, message: exception})
    end
  end


  def clear_devices(conn, _params) do
    Accounts.list_devices
      |> Enum.map(fn device -> Accounts.update_device device, %{flag: 0} end)
      |> Interactions.filter_updates()

    conn
      |> redirect(to: device_path(conn, :index))
  end

  def devices(conn, %{"data" => data}) do
    try do
      case Interactions.update_devices(data) do
        %{errors: errors, updates: updates, ignores: ignores} ->
          json(conn, %{
            status: :completed,
            updates: Enum.count(updates),
            errors: Enum.count(errors),
            ignores: Enum.count(ignores)
          })
        _ ->
          json(conn, :unknown)
      end
    rescue
      exception ->
        Sentry.capture_exception(exception, [stacktrace: System.stacktrace()])
        json(conn, %{status: :failure, message: exception})
    end
  end

  def at_hackerspace(conn, _params) do
    case Notifications.at_hackerspace |> JSON.encode do
      {:ok, response} -> json(conn, response)
      {:error, message} -> json(conn, message)
    end
  end
end
