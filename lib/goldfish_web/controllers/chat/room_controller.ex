defmodule GoldfishWeb.Chat.RoomController do
  use GoldfishWeb, :controller

  alias Goldfish.Chat

  def index(conn, _params) do
    [first | last] = Chat.list_messages()
     redirect(conn, to: admin_room_path(conn, :show, first.room_id))
  end

  def show(conn, %{"id" => room_id}) do
    recent = Chat.list_messages()
    messages = Chat.list_messages(room_id)
    render(conn, "show.html", room_id: room_id, messages: messages,
                              recent_messages: recent)
  end
end
