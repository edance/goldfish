defmodule GoldfishWeb.HomeController do
  use GoldfishWeb, :controller

  alias Goldfish.Chat
  alias Goldfish.CMS

  def index(conn, _params) do
    messages = Chat.list_messages(conn.assigns.room_id)
    pages = CMS.list_pages
    render(conn, "index.html", messages: messages, pages: pages)
  end
end
