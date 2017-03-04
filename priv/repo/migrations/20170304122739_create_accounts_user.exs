defmodule Spejs.Repo.Migrations.CreateSpejs.Accounts.User do
  use Ecto.Migration

  def change do
    create table(:accounts_users) do
      add :name, :string
      add :email, :string
      add :nickname, :string

      timestamps()
    end

  end
end
