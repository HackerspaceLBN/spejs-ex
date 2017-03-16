defmodule Spejs.Repo.Migrations.CreateSpejs.Accounts.Network do
  use Ecto.Migration

  def change do
    create table(:accounts_networks) do
      add :name, :string
      add :mask, :string
      add :address, :string

      timestamps()
    end

    alter table(:accounts_devices) do
      add :network_id, references(:accounts_networks)
    end

  end
end
