defmodule Goldfish.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :body, :string
      add :ip_address, :string
      add :bot, :boolean, default: false, null: false

      # User is not required
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:messages, [:user_id])
  end
end
