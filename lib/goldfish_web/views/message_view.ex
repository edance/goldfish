defmodule GoldfishWeb.MessageView do
  use GoldfishWeb, :view

  def relative_time(datetime) do
    datetime
  end

  def render("message.json", %{message: message}) do
    %{
      id: message.id,
      inserted_at: message.inserted_at,
      body: message.body,
      bot: message.bot || message.user_id,
      ip_address: message.ip_address,
      room_id: message.room_id
    }
  end
end
