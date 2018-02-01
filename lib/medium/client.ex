defmodule Medium.Client do
  defstruct [:access_token, :base_url]
  @enforce_keys [:access_token, :base_url]
  @base_url "https://api.medium.com/v1"

  def new(%{} = params \\ %{}) do
    access_token = System.get_env("MEDIUM_TOKEN")

    %__MODULE__{
      access_token: access_token,
      base_url: @base_url
    } |> Map.merge(params)
  end

  def perform(%__MODULE__{} = client, method, path, body \\ "", headers \\ [], options \\ []) do
    uri = URI.parse(client.base_url)
    |> Map.update!(:path, &(&1 <> path))
    |> URI.to_string

    headers = [
      {"Authorization", "Bearer #{client.access_token}"},
      {"Content-Type", "application/json"},
      {"Accept", "application/json"},
      {"Accept-Charset", "utf-8"}
    ] ++ headers

    HTTPoison.request(method, uri, body, headers, options)
    |> handle_response
  end

  defp handle_response({:ok, %{status_code: status, body: body}})
  when status >= 200 and status < 300 do
    result = body
    |> Poison.Parser.parse!
    |> Map.get("data")
    |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
    {:ok, result}
  end
  defp handle_response({_, response}), do: {:error, response}
end
