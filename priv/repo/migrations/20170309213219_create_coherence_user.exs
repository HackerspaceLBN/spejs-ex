defmodule Spejs.Repo.Migrations.CreateCoherenceUser do
  use Ecto.Migration
  def change do
    alter table(:accounts_users) do
      # add :name, :string # exists
      # add :email, :string # exists

      # authenticatable
      add :password_hash, :string
    end
    create unique_index(:accounts_users, [:email])

  end
end
