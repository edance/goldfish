defmodule GoldfishWeb.Chat.RoomController do
  use GoldfishWeb, :controller

  alias Goldfish.Chat

  def show(conn, %{"id" => room_id}) do
    messages = Chat.list_messages(room_id)
    render(conn, "show.html", room_id: room_id, messages: messages)
  end
end
