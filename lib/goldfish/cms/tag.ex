defmodule Goldfish.CMS.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  alias Goldfish.CMS.Page

  schema "tags" do
    field :name, :string

    many_to_many :pages, Page, join_through: "page_tags"

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
