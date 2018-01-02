defmodule GoldfishWeb.PageController do
  use GoldfishWeb, :controller

  alias Goldfish.CMS

  def index(conn, _params) do
    pages = CMS.list_pages()
    render(conn, "index.html", pages: pages)
  end

  def show(conn, %{"id" => slug}) do
    page =
      slug
      |> CMS.get_page_by_slug!()
      |> CMS.inc_page_views()

    render(conn, "show.html", page: page)
  end
end
