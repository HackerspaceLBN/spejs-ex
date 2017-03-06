defmodule Spejs.Repo.Migrations.CreateSpejs.Accounts.Device do
  use Ecto.Migration

  def change do
    create table(:accounts_devices) do
      add :name, :string
      add :identifier, :string
      add :user_id, references(:accounts_users)

      timestamps()
    end

    create unique_index(:accounts_devices, [:identifier])
  end
end
