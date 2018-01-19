defmodule GoldfishWeb.MessageView do
  use GoldfishWeb, :view

  def relative_time(datetime) do
    Timex.format!(datetime, "%-l:%M %p", :strftime)
  end

  def bot(message) do
    message.bot || message.user_id
  end

  def render("message.json", %{message: message}) do
    %{
      id: message.id,
      inserted_at: message.inserted_at,
      body: message.body,
      bot: bot(message),
      ip_address: message.ip_address,
      room_id: message.room_id
    }
  end
end
