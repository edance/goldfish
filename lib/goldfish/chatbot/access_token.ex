defmodule Goldfish.Chatbot.AccessToken do
  @moduledoc """
  Middleware for google auth from service account

  https://toranbillups.com/blog/archive/2019/07/04/generate-and-sign-jwt-with-elixir-for-google-cloud/

  https://crypt.codemancers.com/posts/2020-08-28-real-world-usecase-for-genserver-agent-in-elixir/
  """

  use Agent

  def start_link() do
    Agent.start_link(fn -> refresh_token() end, name: __MODULE__)
  end

  def token do
    token = Agent.get_and_update(__MODULE__, fn state -> get_token(state) end)
    token
  end

  # ... lines below are exactly the same as in the GenServer snippet ...
  defp refresh_token() do
    jwt = generate_jwt()

    params = %{
      assertion: jwt,
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer"
    }

    url = "https://www.googleapis.com/oauth2/v4/token"
    middleware = [
      {Tesla.Middleware.JSON, engine_opts: [keys: :atoms]},
      Tesla.Middleware.FormUrlencoded
    ]
    client = Tesla.client(middleware)

    %{status: 200, body: body} = Tesla.post!(client, url, params)
    Map.put(body, :expires_in, :os.system_time(:seconds) + body.expires_in)
  end

  defp get_token(%{expires_in: expires_in, access_token: token} = state) do
    now = :os.system_time(:seconds)

    has_aged? = now + 1 > expires_in

    if has_aged? do
      auth = refresh_token()
      {auth.access_token, auth}
    else
      # No need to refresh, send back the same token
      {token, state}
    end
  end

  def generate_jwt do
    extra_claims = %{
      "iss" => iss(),
      "scope" => "https://www.googleapis.com/auth/dialogflow",
      "aud" => "https://www.googleapis.com/oauth2/v4/token"
    }
    signer = Joken.Signer.create("RS256", %{"pem" => pem()}, %{"kid" => kid()})
    Goldfish.Chatbot.Token.generate_and_sign!(extra_claims, signer)
  end

  def iss do
    System.get_env("GOOGLE_CLIENT_EMAIL")
  end

  def kid do
    System.get_env("GOOGLE_PRIVATE_KEY_ID")
  end

  def pem do
    System.get_env("GOOGLE_PRIVATE_KEY")
    |> String.replace(~r/\\n/, "\n")
  end
end
