defmodule Goldfish.Repo.Migrations.AddPublishedAtToPages do
  use Ecto.Migration

  def change do
    alter table(:pages) do
      add :published_at, :utc_datetime
    end
  end
end
