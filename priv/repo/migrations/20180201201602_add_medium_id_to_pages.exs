defmodule Goldfish.Repo.Migrations.AddMediumIdToPages do
  use Ecto.Migration

  def change do
    alter table(:pages) do
      add :medium_id, :string
    end
  end
end
