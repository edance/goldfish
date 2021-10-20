defmodule Goldfish.CMS.Page do
  use Ecto.Schema
  import Ecto.Changeset
  alias Goldfish.CMS.{Page, Author, Tag}


  schema "pages" do
    field :body, :string
    field :title, :string
    field :slug, :string
    field :views, :integer
    field :draft, :boolean, default: true
    field :medium_id, :string
    field :published_at, :utc_datetime

    belongs_to :author, Author

    many_to_many :tags, Tag, join_through: "page_tags"

    timestamps()
  end

  @doc false
  def changeset(%Page{} = page, attrs) do
    page
    |> cast(attrs, [:title, :body, :slug, :draft, :medium_id])
    |> validate_required([:title, :body, :slug])
    |> set_published_at()
  end

  defp set_published_at(%{changes: %{draft: false}} = changeset) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)
    put_change(changeset, :published_at, now)
  end

  defp set_published_at(changeset), do: changeset
end
