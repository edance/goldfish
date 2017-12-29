defmodule Goldfish.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias Goldfish.Chat.Message
  alias Goldfish.Accounts.User


  schema "messages" do
    field :body, :string
    field :room_id, :string
    field :bot, :boolean, default: false
    field :ip_address, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(%Message{} = message, attrs) do
    message
    |> cast(attrs, [:body, :ip_address, :bot, :room_id])
    |> validate_required([:body, :room_id])
    |> validate_length(:body, min: 1, max: 255)
  end
end
