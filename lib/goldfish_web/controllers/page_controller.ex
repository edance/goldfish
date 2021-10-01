defmodule GoldfishWeb.PageController do
  use GoldfishWeb, :controller

  alias Goldfish.CMS

  def index(conn, _params) do
    pages = CMS.list_pages()
    render(conn, "index.html", pages: pages)
  end

  def show(conn, %{"id" => slug}) do
    data = CMS.get_page_data_by_slug!(slug)
    CMS.inc_page_views(data.page)

    render(conn, "show.html", page: data.page, data: data)
  end
end
