defmodule Mix.Tasks.UploadIntents do
  alias ApiAi.Intent

  def run(_) do
    Mix.Task.run("app.start", [])
    path = File.cwd! |> Path.join("intents.yml")
    [intents] = YamlElixir.read_all_from_file(path)
    intents
    |> Enum.map(&map_intent/1)
    |> Enum.map(&Intent.create_intent/1)
  end

  def map_intent({k, v}) do
    %Intent{
      name: k,
      responses: [
        %{
          messages: [
            %{
              speech: v["response"],
              type: 0
            },
          ]
        }
      ],
      userSays: Enum.map(v["user"], &map_user/1)
    }
  end

  def map_user(v) do
    %{
      data: [
        %{
          text: v
        }
      ]
    }
  end
end
