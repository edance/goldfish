defmodule Goldfish.Chatbot.Client do
  @moduledoc """
  Chatbot client
  """

  use Tesla

  alias Goldfish.Chatbot.Middleware.OAuth

  plug Tesla.Middleware.JSON

  def new(opts) when is_list(opts) do
    Tesla.client([
      {Middleware.OAuth, opts}
    ])
  end

  def new, do: new([])
end
