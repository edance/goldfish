defmodule GoldfishWeb.NotificationChannel do
  use GoldfishWeb, :channel

  alias Goldfish.Chat

  def join("notifications", _params, socket) do
    if Guardian.Phoenix.Socket.authenticated?(socket) do
      {:ok, socket}
    else
      :error
    end
  end
end
