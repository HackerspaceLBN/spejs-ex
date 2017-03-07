defmodule Spejs.Repo.Migrations.ChangeFieldsInDevice do
  use Ecto.Migration

  def change do
    rename table(:accounts_devices), :identifier, to: :mac

    alter table(:accounts_devices) do
      add :flag, :integer
      add :ip, :string
    end
  end
end
