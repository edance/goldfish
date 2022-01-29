defmodule Goldfish.MessageReporter do
  @moduledoc """
  This module reports information to slack
  """

  alias Goldfish.Chat.Message
  alias Slack.Web.Chat

  def report_new_message(%Message{bot: true, body: body}) do
    text = "Bot: #{body}"
    Chat.post_message("#goldfish", text)
  end
  def report_new_message(%Message{body: body, ip_address: ip_address}) do
    text = "#{ip_address}: #{body}"
    Chat.post_message("#goldfish", text)
  end
end
