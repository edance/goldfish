defmodule Goldfish.CMS.Author do
  use Ecto.Schema
  import Ecto.Changeset
  alias Goldfish.CMS.{Author, Page}


  schema "authors" do
    field :bio, :string
    field :genre, :string
    field :role, :string

    belongs_to :user, Goldfish.Accounts.User

    has_many :pages, Page

    timestamps()
  end

  @doc false
  def changeset(%Author{} = author, attrs) do
    author
    |> cast(attrs, [:bio, :role, :genre])
    |> validate_required([:bio, :role, :genre])
    |> unique_constraint(:user_id)
  end
end
