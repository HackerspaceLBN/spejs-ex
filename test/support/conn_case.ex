defmodule SpejsWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      import SpejsWeb.Router.Helpers

      # The default endpoint for testing
      @endpoint SpejsWeb.Endpoint

      def login_user(%{conn: conn}) do
        {:ok, user} = Spejs.Accounts.create_user(%{
          email: "login@example.com",
          nickname: "current_user",
          name: "current user",
          password: "current_password",
          password_confirmation: "current_password"
        })

        {:ok, conn: Plug.Conn.assign(conn, :current_user, user), user: user}
      end

      def login_user(%{conn: conn}, %{} = user) do
        {:ok, conn: Plug.Conn.assign(conn, :current_user, user), user: user}
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Spejs.Repo)
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Spejs.Repo, {:shared, self()})
    end
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
