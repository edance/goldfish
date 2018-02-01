defmodule Medium.Post do
  defstruct [:id, :title, :contentFormat, :content, :tags, :canonicalUrl,
             :publishStatus, :license, :notifyFollowers]

  alias Medium.{Client, User}

  def create_post(%__MODULE__{} = post), do: Client.new() |> create_post(post)
  def create_post(%Client{} = client, %__MODULE__{} = post) do
    user = User.get!(client)
    path = "/users/#{user.id}/posts"
    body = post |> Poison.encode!
    Client.perform(client, :post, path, body)
  end
end
