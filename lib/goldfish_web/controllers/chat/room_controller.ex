defmodule GoldfishWeb.Chat.RoomController do
  use GoldfishWeb, :controller

  alias Goldfish.Chat

  def index(conn, _params) do
    [first | last] = Chat.list_messages()
     redirect(conn, to: Routes.admin_room_path(conn, :show, first.room_id))
  end

  def show(conn, %{"id" => room_id}) do
    rooms = Chat.list_rooms()
    messages = Chat.list_messages(room_id)
    render(conn, "show.html", room_id: room_id, messages: messages, rooms: rooms)
  end
end
