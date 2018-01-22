defmodule ApiAi.Intent do
  defstruct [:id, :name, responses: [], userSays: []]
  @enforce_keys [:name]
  @moduledoc """
  ApiAi.Intent module

  Example syntax:

  ```
  i = %ApiAi.Intent{
    id: "31392be8-1f5f-44b6-b952-2bdfb95e0378",
    name: "personal.name",
    responses: [
      %{
        messages: [
          %{
            speech: ["My name is Evan", "I am Evan"],
            type: 0
          }
        ]
      }
    ],
    userSays: [
      %{
        data: [
          %{
            text: "What is your name?",
          }
        ]
      },
      %{
        data: [
          %{
            text: "What's your name?",
          }
        ]
      },
    ]
  }
  ```
  """

  alias ApiAi.Client

  def get_all(), do: Client.new() |> get_all()
  def get_all(%Client{} = client) do
    path = "/intents"
    Client.perform(client, :get, path)
  end

  def get_all!(), do: Client.new() |> get_all!()
  def get_all!(%Client{} = client) do
    case get_all(client) do
      {:ok, response} -> response
      {:error, response} -> throw(response)
    end
  end

  def get(id), do: Client.new() |> get(id)
  def get(%Client{} = client, id) do
    path = "/intents/#{id}"
    Client.perform(client, :get, path)
  end

  def get!(id), do: Client.new() |> get!(id)
  def get!(%Client{} = client, id) do
    case get(client, id) do
      {:ok, response} -> response
      {:error, response} -> throw(response)
    end
  end

  def create_intent(%__MODULE__{} = intent), do: Client.new() |> create_intent(intent)
  def create_intent(%Client{} = client, %__MODULE__{} = intent) do
    path = "/intents"
    body = intent |> Poison.encode!
    ApiAi.Client.perform(client, :post, path, body)
  end

  def update_intent(%__MODULE__{} = intent), do: Client.new() |> update_intent(intent)
  def update_intent(%Client{} = client, %__MODULE__{} = intent) do
    path = "/intents/#{intent.id}"
    body = intent |> Poison.encode!
    ApiAi.Client.perform(client, :put, path, body)
  end
end
