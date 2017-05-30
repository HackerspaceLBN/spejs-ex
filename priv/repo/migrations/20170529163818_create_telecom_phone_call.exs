defmodule Spejs.Repo.Migrations.CreateSpejs.Telecom.PhoneCall do
  use Ecto.Migration

  def change do
    create table(:telecom_phone_calls) do
      add :source, :string
      add :destination, :string
      add :stop_at, :naive_datetime
      add :start_at, :naive_datetime

      timestamps()
    end

  end
end
