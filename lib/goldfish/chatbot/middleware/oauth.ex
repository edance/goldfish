defmodule Goldfish.Chatbot.Middleware.OAuth do
  @moduledoc """
  Middleware for google auth from service account

  https://toranbillups.com/blog/archive/2019/07/04/generate-and-sign-jwt-with-elixir-for-google-cloud/
  """

  @behaviour Tesla.Middleware

  def call(env, next, _opts) do
    env
    |> Tesla.run(next)
  end

  def get_token() do
    jwt = generate_jwt()

    params = %{
      assertion: jwt,
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer"
    }

    url = "https://www.googleapis.com/oauth2/v4/token"
    middleware = [
      Tesla.Middleware.JSON,
      Tesla.Middleware.FormUrlencoded
    ]

    {:ok, response} = Tesla.client(middleware) |> Tesla.post(url, params)
    response.body["access_token"]
  end

  def generate_jwt do
    extra_claims = %{
      "iss" => iss,
      "scope" => "https://www.googleapis.com/auth/dialogflow",
      "aud" => "https://www.googleapis.com/oauth2/v4/token"
    }
    signer = Joken.Signer.create("RS256", %{"pem" => pem}, %{"kid" => kid})
    jwt = Goldfish.Chatbot.Token.generate_and_sign!(extra_claims, signer)
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
