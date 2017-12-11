defmodule Goldfish.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :password_hash, :string

      timestamps()
    end

    # Restrict duplicate emails for a user
    create unique_index(:users, :email)
  end
end
