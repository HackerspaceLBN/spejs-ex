defmodule Spejs.Telecom do
  @moduledoc """
  The boundary for the Telecom system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Spejs.Repo

  alias Spejs.Telecom.PhoneCall

  @doc """
  Returns the list of phone_calls.

  ## Examples

      iex> list_phone_calls()
      [%PhoneCall{}, ...]

  """
  def list_phone_calls do
    Repo.all(PhoneCall)
  end

  def get_started_phone_call(%{source: source}) do
    PhoneCall 
    |> where([p], p.source == ^source)
    |> where([p], is_nil(p.stop_at))
    |> Repo.all
  end
  def get_started_phone_call(%{destination: destination}) do
    PhoneCall 
    |> where([p], p.destination == ^destination)
    |> where([p], is_nil(p.stop_at))
    |> Repo.all
  end
  def get_started_phone_call(%{any: number}) do
    PhoneCall 
    |> where([p], p.destination == ^number or p.source == ^number )
    |> where([p], is_nil(p.stop_at))
    |> Repo.all
  end
  def get_started_phone_call(_) do
    PhoneCall 
    |> where([p], is_nil(p.stop_at))
    |> Repo.all
  end

  @doc """
  Gets a single phone_call.

  Raises `Ecto.NoResultsError` if the Phone call does not exist.

  ## Examples

      iex> get_phone_call!(123)
      %PhoneCall{}

      iex> get_phone_call!(456)
      ** (Ecto.NoResultsError)

  """
  def get_phone_call!(id), do: Repo.get!(PhoneCall, id)

  @doc """
  Creates a phone_call.

  ## Examples

      iex> create_phone_call(%{field: value})
      {:ok, %PhoneCall{}}

      iex> create_phone_call(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_phone_call(attrs \\ %{}) do
    %PhoneCall{}
    |> phone_call_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a phone_call.

  ## Examples

      iex> update_phone_call(phone_call, %{field: new_value})
      {:ok, %PhoneCall{}}

      iex> update_phone_call(phone_call, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_phone_call(%PhoneCall{} = phone_call, attrs) do
    phone_call
    |> phone_call_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PhoneCall.

  ## Examples

      iex> delete_phone_call(phone_call)
      {:ok, %PhoneCall{}}

      iex> delete_phone_call(phone_call)
      {:error, %Ecto.Changeset{}}

  """
  def delete_phone_call(%PhoneCall{} = phone_call) do
    Repo.delete(phone_call)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking phone_call changes.

  ## Examples

      iex> change_phone_call(phone_call)
      %Ecto.Changeset{source: %PhoneCall{}}

  """
  def change_phone_call(%PhoneCall{} = phone_call) do
    phone_call_changeset(phone_call, %{})
  end

  defp phone_call_changeset(%PhoneCall{} = phone_call, attrs) do
    phone_call
    |> cast(attrs, [:source, :destination, :start_at, :stop_at])
    |> validate_required([:source, :destination])
  end
end
