defmodule Goldfish.CMS do
  @moduledoc """
  The CMS context.
  """

  import Ecto.Query, warn: false
  alias Goldfish.Repo

  alias Goldfish.CMS.{Author, Page}
  alias Goldfish.Accounts.User

  @doc """
  Returns the list of pages.

  ## Examples

      iex> list_pages()
      [%Page{}, ...]

  """
  def list_pages do
    Page
    |> recently_published()
    |> Repo.all()
    |> Repo.preload([:tags, author: :user])
  end

  def list_pages(%{draft: true}) do
    Page
    |> order_by([a], [desc: a.updated_at])
    |> Repo.all()
    |> Repo.preload([:tags, author: :user])
  end

  def list_project_pages() do
    Page
    |> by_tag("project")
    |> recently_published()
    |> Repo.all()
    |> Repo.preload([:tags, author: :user])
  end

  def list_running_pages() do
    Page
    |> by_tag("running")
    |> recently_published()
    |> Repo.all()
    |> Repo.preload([:tags, author: :user])
  end

  def get_about_page() do
    query = from p in Page,
      join: t in assoc(p, :tags),
      where: [draft: false],
      where: t.name == "about",
      order_by: [desc: :published_at],
    limit: 1

    Repo.one(query)
    |> Repo.preload([:tags, author: :user])
  end

  def recently_published(query) do
    from q in query,
      where: [draft: false],
      order_by: [desc: :published_at]
  end

  def by_tag(query, tag_name) do
    from q in query,
      join: t in assoc(q, :tags),
      where: t.name == ^tag_name
  end

  defp query_pages_by_tag(tag_name) do
    from p in Page,
      join: t in assoc(p, :tags),
      where: [draft: false],
      where: t.name == ^tag_name,
      order_by: [desc: :updated_at]
  end

  @doc """
  Gets a single page.

  Raises `Ecto.NoResultsError` if the Page does not exist.

  ## Examples

      iex> get_page!(123)
      %Page{}

      iex> get_page!(456)
      ** (Ecto.NoResultsError)

  """
  def get_page!(id) do
    Page
    |> Repo.get!(id)
    |> Repo.preload([:tags, author: :user])
  end

  @doc """
  Gets a single page by unique slug.

  Raises `Ecto.NoResultsError` if the Page does not exist.

  ## Examples

  iex> get_page_by_slug!(123)
  %Page{}

  iex> get_page_by_slug!(456)
  ** (Ecto.NoResultsError)

  """
  def get_page_by_slug!(slug) do
    query = from p in Page,
      where: p.slug == ^slug,
      preload: [:tags, author: :user]
    Repo.one!(query)
  end

  def get_page_data_by_slug!(slug) do
    set = from p in Page,
      where: p.draft == ^false,
      order_by: p.inserted_at,
      windows: [w: [order_by: p.inserted_at]],
      select: %{
        slug: p.slug,
        next_slug: lead(p.slug) |> over(:w),
        next_title: lead(p.title) |> over(:w),
        prev_slug: lag(p.slug) |> over(:w),
        prev_title: lag(p.title) |> over(:w)
      }

    query = from p in Page,
      where: p.slug == ^slug,
      join: s in ^subquery(set), on: p.slug == s.slug,
      select: %{
        page: p,
        next_slug: s.next_slug,
        next_title: s.next_title,
        prev_slug: s.prev_slug,
        prev_title: s.prev_title
      }

    Repo.one!(query)
  end

  @doc """
  Creates a page.

  ## Examples

      iex> create_page(%Author{}, %{field: value})
      {:ok, %Page{}}

      iex> create_page(%Author{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_page(%Author{} = author, attrs \\ %{}) do
    %Page{}
    |> Page.changeset(attrs)
    |> put_tags(attrs)
    |> Ecto.Changeset.put_change(:author_id, author.id)
    |> Repo.insert()
  end

  @doc """
  Updates a page.

  ## Examples

      iex> update_page(page, %{field: new_value})
      {:ok, %Page{}}

      iex> update_page(page, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_page(%Page{} = page, attrs) do
    page
    |> Page.changeset(attrs)
    |> put_tags(attrs)
    |> Repo.update()
  end

  defp put_tags(changeset, %{"tags" => tags}) when is_list(tags) do
    tags = list_tags(tags)
    Ecto.Changeset.put_assoc(changeset, :tags, tags)
  end

  defp put_tags(changeset, attrs) do
    changeset
  end

  @doc """
  Deletes a Page.

  ## Examples

      iex> delete_page(page)
      {:ok, %Page{}}

      iex> delete_page(page)
      {:error, %Ecto.Changeset{}}

  """
  def delete_page(%Page{} = page) do
    Repo.delete(page)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking page changes.

  ## Examples

      iex> change_page(page)
      %Ecto.Changeset{source: %Page{}}

  """
  def change_page(%Page{} = page) do
    Page.changeset(page, %{})
  end

  alias Goldfish.CMS.Tag

  def list_tags() do
    Repo.all(Tag)
  end

  def list_tags(ids) do
    query = from t in Tag, where: t.id in ^ids
    Repo.all(query)
  end

  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  alias Goldfish.CMS.Author

  @doc """
  Returns the list of authors.

  ## Examples

      iex> list_authors()
      [%Author{}, ...]

  """
  def list_authors do
    Repo.all(Author)
  end

  @doc """
  Gets a single author.

  Raises `Ecto.NoResultsError` if the Author does not exist.

  ## Examples

      iex> get_author!(123)
      %Author{}

      iex> get_author!(456)
      ** (Ecto.NoResultsError)

  """
  def get_author!(id) do
    Author
    |> Repo.get!(id)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a author.

  ## Examples

      iex> create_author(%{field: value})
      {:ok, %Author{}}

      iex> create_author(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_author(attrs \\ %{}) do
    %Author{}
    |> Author.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a author.

  ## Examples

      iex> update_author(author, %{field: new_value})
      {:ok, %Author{}}

      iex> update_author(author, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_author(%Author{} = author, attrs) do
    author
    |> Author.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Author.

  ## Examples

      iex> delete_author(author)
      {:ok, %Author{}}

      iex> delete_author(author)
      {:error, %Ecto.Changeset{}}

  """
  def delete_author(%Author{} = author) do
    Repo.delete(author)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking author changes.

  ## Examples

      iex> change_author(author)
      %Ecto.Changeset{source: %Author{}}

  """
  def change_author(%Author{} = author) do
    Author.changeset(author, %{})
  end

  @doc """
  Returns an author given a user and will create an author if one does not exist

  ## Examples

      iex> ensure_author_exists(user)
      %Author{}
  """
  def ensure_author_exists(%User{} = user) do
    %Author{user_id: user.id}
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.unique_constraint(:user_id)
    |> Repo.insert()
    |> handle_existing_author()
  end

  defp handle_existing_author({:ok, author}), do: author
  defp handle_existing_author({:error, changeset}) do
    Repo.get_by!(Author, user_id: changeset.data.user_id)
  end

  def inc_page_views(%Page{} = page) do
    {1, [%Page{views: views}]} =
      from(p in Page, where: p.id == ^page.id, select: [:views])
    |> Repo.update_all(inc: [views: 1])

    put_in(page.views, views)
  end
end
