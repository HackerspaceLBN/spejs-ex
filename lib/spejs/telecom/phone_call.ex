defmodule Spejs.Telecom.PhoneCall do
  use Ecto.Schema

  schema "telecom_phone_calls" do
    field :destination, :string
    field :source, :string
    field :start_at, :naive_datetime
    field :stop_at, :naive_datetime

    timestamps()
  end
end