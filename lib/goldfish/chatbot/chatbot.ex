defmodule Goldfish.Chatbot do
  @moduledoc """
  Chatbot client
  """

  # "https://dialogflow.clients6.google.com/v2beta1/projects/resume-f1825/locations/global/agent/sessions/8d5a571f-7b10-9547-066e-fe17578446bc:detectIntent"

  alias Goldfish.Chatbot.AccessToken

  def client() do
    project_id = "resume-f1825"
    base_path = "/v2beta1/projects/#{project_id}"
    Tesla.client([
      {Tesla.Middleware.BaseUrl, "https://dialogflow.googleapis.com#{base_path}"},
      {Tesla.Middleware.JSON, engine_opts: [keys: :atoms]},
      {Tesla.Middleware.BearerAuth, token: AccessToken.token()}
    ])
  end

  # https://cloud.google.com/dialogflow/es/docs/reference/rest/v2beta1/projects.agent.environments.users.sessions/detectIntent
  def detect_intent(msg, session_id) do
    path = "/locations/global/agent/sessions/#{session_id}:detectIntent"
    data = %{
      queryInput: %{
        text: %{
          text: msg,
          languageCode: "en"
        }
      }
    }

    with {:ok, response} <- Tesla.post(client(), path, data),
         %{status: 200, body: body} <- response do
      {:ok, body.queryResult.fulfillmentText}
    else
      _ -> {:error}
    end
  end
end
