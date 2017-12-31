defmodule GoldfishWeb.RoomChannel do
  use GoldfishWeb, :channel

  alias Goldfish.Chat

  def join("room:" <> room_id, _params, socket) do
    {:ok, assign(socket, :room_id, room_id)}
  end

  def handle_in("new_msg", params, socket) do
    case create_message(socket, params) do
      {:ok, message} ->
        broadcast_message(socket, message)
        {:reply, :ok, socket}
      {:error, _changeset} ->
        {:reply, :error, socket}
    end
  end

  defp create_message(socket, params) do
    params = Map.put(params, "room_id", socket.assigns.room_id)
    if Guardian.Phoenix.Socket.authenticated?(socket) do
      Chat.create_message(socket.assigns.current_user, params)
    else
      Chat.create_message(params)
    end
  end

  defp broadcast_message(socket, message) do
    # rendered_message = Phoenix.View.render_one(message, Sling.MessageView, "message.json")
    rendered_message = %{body: message.body}
    GoldfishWeb.Endpoint.broadcast("notifications", "new_msg", rendered_message)
    broadcast!(socket, "new_msg", rendered_message)
  end
end
