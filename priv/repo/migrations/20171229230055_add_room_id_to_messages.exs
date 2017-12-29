defmodule Goldfish.Repo.Migrations.AddRoomIdToMessages do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :room_id, :string, null: false
    end

    create index(:messages, :room_id)
  end
end
