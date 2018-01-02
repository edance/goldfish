defmodule Goldfish.CMS.Page do
  use Ecto.Schema
  import Ecto.Changeset
  alias Goldfish.CMS.{Page, Author}


  schema "pages" do
    field :body, :string
    field :title, :string
    field :slug, :string
    field :views, :integer

    belongs_to :author, Author

    timestamps()
  end

  @doc false
  def changeset(%Page{} = page, attrs) do
    page
    |> cast(attrs, [:title, :body, :slug])
    |> validate_required([:title, :body, :slug])
  end
end
