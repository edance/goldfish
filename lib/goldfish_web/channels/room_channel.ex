defmodule GoldfishWeb.RoomChannel do
  use GoldfishWeb, :channel

  alias Goldfish.Chat
  alias Goldfish.Chatbot
  alias GoldfishWeb.Presence

  def join("room:" <> room_id, _params, socket) do
    case Phoenix.Token.verify(socket, "room", room_id) do
      {:ok, ip_address} ->
        socket = socket
        |> assign(:room_id, room_id)
        |> assign(:ip_address, ip_address)
        {:ok, socket}
      {:error, _} ->
        :error
    end
  end

  def handle_in("new_msg", params, socket) do
    case create_message(socket, params) do
      {:ok, message} ->
        broadcast_message(socket, message)
        send_bot_response(socket, message)
        {:reply, :ok, socket}
      {:error, _changeset} ->
        {:reply, :error, socket}
    end
  end

  def send_bot_response(socket, %{body: body}) do
    # sessionId cannot be longer than 36 characters
    session_id = socket.assigns.room_id |> String.slice(0..35)
    case Chatbot.detect_intent(body, session_id) do
      {:ok, message} -> create_bot_message(socket, message, Presence.list("notifications"))
      {:error} -> nil
    end
  end

  defp create_message(socket, params) do
    params = params
    |> Map.put("room_id", socket.assigns.room_id)
    |> Map.put("ip_address", socket.assigns.ip_address)
    if Guardian.Phoenix.Socket.authenticated?(socket) do
      Chat.create_message(socket.assigns.current_user, params)
    else
      Chat.create_message(params)
    end
  end

  defp broadcast_message(socket, message) do
    rendered_message = Phoenix.View.render_one(message, GoldfishWeb.MessageView, "message.json")
    GoldfishWeb.Endpoint.broadcast("notifications", "new_msg", rendered_message)
    broadcast!(socket, "new_msg", rendered_message)
  end

  defp create_bot_message(socket, message, online_users) when online_users == %{} do
    attrs = %{body: message,
              bot: true,
              room_id: socket.assigns.room_id}
    case Chat.create_message(attrs) do
      {:ok, message} -> broadcast_message(socket, message)
    end
  end

  defp create_bot_message(_socket, _message, _users), do: nil
end
