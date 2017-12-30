defmodule GoldfishWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "room:*", GoldfishWeb.RoomChannel
  channel "notifications", GoldfishWeb.NotificationChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket, timeout: 45_000

  @doc """
  Connects and authenticates a user with a token
  """
  def connect(%{"token" => token}, socket) do
    case Guardian.Phoenix.Socket.authenticate(socket, Goldfish.Guardian, token) do
      {:ok, authed_socket} -> set_user(authed_socket)
      {:error, _} -> :error
    end
  end

  @doc """
  Connects and authenticates an anonymous user
  """
  def connect(_params, socket) do
    {:ok, socket}
  end

  defp set_user(socket) do
    case Guardian.Phoenix.Socket.current_resource(socket) do
      nil -> :error
      user -> {:ok, assign(socket, :current_user, user)}
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     GoldfishWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
