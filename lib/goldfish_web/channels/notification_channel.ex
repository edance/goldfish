defmodule GoldfishWeb.NotificationChannel do
  use GoldfishWeb, :channel

  alias Goldfish.Chat
  alias GoldfishWeb.Presence

  def join("notifications", _params, socket) do
    if Guardian.Phoenix.Socket.authenticated?(socket) do
      send(self(), :after_join)
      {:ok, socket}
    else
      :error
    end
  end

  def handle_info(:after_join, socket) do
    push(socket, "presence_state", Presence.list(socket))
    user = socket.assigns.current_user
    time = System.system_time(:seconds)
    {:ok, _} = Presence.track(socket, user.id, %{online_at: inspect(time)})
    {:noreply, socket}
  end
end
