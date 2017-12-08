defmodule GoldfishWeb.RoomChannel do
  use GoldfishWeb, :channel

  def join("room:" <> room_id, payload, socket) do
    {:ok, socket}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    broadcast!(socket, "new_msg", %{body: body})
    {:noreply, socket}
  end
end
