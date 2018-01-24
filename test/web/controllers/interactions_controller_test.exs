defmodule SpejsWeb.InteractionsControllerTest do
  use SpejsWeb.ConnCase

  @moduletag :wip
  test "don't fail with empty update devices request", %{conn: conn}  do
  	conn = post conn, interactions_path(conn, :devices), %{}
  	assert response(conn, 200)
  end

  @moduletag :wip
  test "process update devices request with empty data", %{conn: conn} do
  	conn = post conn, interactions_path(conn, :devices), %{"data" => []}
  	assert json_response(conn, 200) == %{
  		"status" => "completed",
  		"errors" => 0,
  		"ignores" => 0,
  		"updates" => 0
    }
  end

  @moduletag :wip
  test "process update devices request with empty device data", %{conn: conn} do
  	conn = post conn, interactions_path(conn, :devices), %{"data" => [%{}]}
  	assert json_response(conn, 200) == %{
  		"status" => "completed",
  		"errors" => 0,
  		"ignores" => 0,
  		"updates" => 0
    }
  end
end