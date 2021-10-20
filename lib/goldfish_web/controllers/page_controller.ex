defmodule GoldfishWeb.PageController do
  use GoldfishWeb, :controller

  alias Goldfish.CMS

  def index(conn, _params) do
    pages = CMS.list_pages()
    render(conn, "index.html", pages: pages)
  end

  def projects(conn, _params) do
    pages = CMS.list_project_pages()
    render(conn, "projects.html", pages: pages)
  end

  def running(conn, _params) do
    pages = CMS.list_running_pages()
    render(conn, "running.html", pages: pages)
  end

  def about(conn, _params) do
    page = CMS.get_about_page()
    |> CMS.inc_page_views()

    render(conn, "about.html", page: page)
  end

  def show(conn, %{"id" => slug}) do
    data = CMS.get_page_data_by_slug!(slug)
    CMS.inc_page_views(data.page)

    render(conn, "show.html", page: data.page, data: data)
  end
end
