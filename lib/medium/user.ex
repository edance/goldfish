defmodule Medium.User do
  defstruct [:id, :name, :url, :username]

  alias Medium.Client

  def get(), do: Client.new() |> get()
  def get(%Client{} = client) do
    path = "/me"
    case Client.perform(client, :get, path) do
      {:ok, response} -> {:ok, struct(Medium.User, response)}
    end
  end

  def get!(), do: Client.new() |> get!()
  def get!(%Client{} = client) do
    case get(client) do
      {:ok, response} -> response
      {:error, response} -> throw(response)
    end
  end
end
