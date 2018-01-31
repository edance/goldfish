defmodule Goldfish.Repo.Migrations.AddDraftToPages do
  use Ecto.Migration

  def change do
    alter table(:pages) do
      add :draft, :boolean, null: false, default: true
    end
  end
end
