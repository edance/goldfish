defmodule Goldfish.Repo.Migrations.CreatePageTags do
  use Ecto.Migration

  def change do
    create table(:page_tags) do
      add :tag_id, references(:tags, on_delete: :delete_all)
      add :page_id, references(:pages, on_delete: :delete_all)
    end

    create unique_index(:page_tags, [:tag_id, :page_id])
  end
end
