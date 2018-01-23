defmodule GoldfishWeb.FeedController do
  use GoldfishWeb, :controller

  alias Goldfish.CMS

  def index(conn, _params) do
    pages = CMS.list_pages()
    render(conn, "index.xml", pages: pages)
  end
end
