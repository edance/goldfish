defmodule GoldfishWeb.HomeController do
  use GoldfishWeb, :controller

  alias Goldfish.Chat

  def index(conn, _params) do
    messages = Chat.list_messages(conn.assigns.room_id)
    render(conn, "index.html", messages: messages)
  end
end
