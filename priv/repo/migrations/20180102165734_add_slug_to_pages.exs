defmodule Goldfish.Repo.Migrations.AddSlugToPages do
  use Ecto.Migration

  def change do
    alter table(:pages) do
      add :slug, :string, null: false
    end

    create unique_index(:pages, :slug)
  end
end
