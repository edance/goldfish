defmodule GoldfishWeb.RoomChannel do
  use GoldfishWeb, :channel

  alias Goldfish.Chat

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
        {:reply, :ok, socket}
      {:error, _changeset} ->
        {:reply, :error, socket}
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
end
