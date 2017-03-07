defmodule Spejs.Repo.Migrations.AddTypeToUsers do
  use Ecto.Migration

  def change do
    alter table(:accounts_users) do
      add :type, :string, default: "user"
    end

    create index(:accounts_users, [:type])
  end
end
