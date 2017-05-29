defmodule Spejs.TelecomTest do
  use Spejs.DataCase

  alias Spejs.Telecom
  alias Spejs.Telecom.PhoneCall

  @create_attrs %{destination: "some destination", source: "some source", stop_at: ~N[2010-04-17 14:00:00.000000]}
  @update_attrs %{destination: "some updated destination", source: "some updated source", stop_at: ~N[2011-05-18 15:01:01.000000]}
  @invalid_attrs %{destination: nil, source: nil, stop_at: nil}

  def fixture(:phone_call, attrs \\ @create_attrs) do
    {:ok, phone_call} = Telecom.create_phone_call(attrs)
    phone_call
  end

  test "list_phone_calls/1 returns all phone_calls" do
    phone_call = fixture(:phone_call)
    assert Telecom.list_phone_calls() == [phone_call]
  end

  test "get_phone_call! returns the phone_call with given id" do
    phone_call = fixture(:phone_call)
    assert Telecom.get_phone_call!(phone_call.id) == phone_call
  end

  test "create_phone_call/1 with valid data creates a phone_call" do
    assert {:ok, %PhoneCall{} = phone_call} = Telecom.create_phone_call(@create_attrs)
    assert phone_call.destination == "some destination"
    assert phone_call.source == "some source"
    assert phone_call.stop_at == ~N[2010-04-17 14:00:00.000000]
  end

  test "create_phone_call/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Telecom.create_phone_call(@invalid_attrs)
  end

  test "update_phone_call/2 with valid data updates the phone_call" do
    phone_call = fixture(:phone_call)
    assert {:ok, phone_call} = Telecom.update_phone_call(phone_call, @update_attrs)
    assert %PhoneCall{} = phone_call
    assert phone_call.destination == "some updated destination"
    assert phone_call.source == "some updated source"
    assert phone_call.stop_at == ~N[2011-05-18 15:01:01.000000]
  end

  test "update_phone_call/2 with invalid data returns error changeset" do
    phone_call = fixture(:phone_call)
    assert {:error, %Ecto.Changeset{}} = Telecom.update_phone_call(phone_call, @invalid_attrs)
    assert phone_call == Telecom.get_phone_call!(phone_call.id)
  end

  test "delete_phone_call/1 deletes the phone_call" do
    phone_call = fixture(:phone_call)
    assert {:ok, %PhoneCall{}} = Telecom.delete_phone_call(phone_call)
    assert_raise Ecto.NoResultsError, fn -> Telecom.get_phone_call!(phone_call.id) end
  end

  test "change_phone_call/1 returns a phone_call changeset" do
    phone_call = fixture(:phone_call)
    assert %Ecto.Changeset{} = Telecom.change_phone_call(phone_call)
  end
end
