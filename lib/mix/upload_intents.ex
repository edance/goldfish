defmodule Mix.Tasks.UploadIntents do
  alias ApiAi.{Intent}

  def run(_) do
    Mix.Task.run("app.start", [])
    path = File.cwd! |> Path.join("intents.yml")
    [intents] = YamlElixir.read_all_from_file(path)
    map = create_intent_map()
    intents
    |> Enum.map(&map_intent/1)
    |> Enum.map(fn(x) -> create_or_update_intent(x, map) end)
  end

  def create_intent_map do
    Intent.get_all!()
    |> Enum.map(fn(v) -> {v["name"], v["id"]} end)
    |> Enum.into(%{})
  end

  def create_or_update_intent(%Intent{} = intent, id_map) do
    case id_map[intent.name] do
      nil -> Intent.create_intent(intent)
      id -> update_intent(%{intent | id: id})
    end
  end

  def update_intent(intent) do
    user_says = intent
    |> existing_user_says()
    |> Enum.map(&map_user/1)
    Intent.update_intent(%{intent | userSays: user_says})
  end

  def existing_user_says(%Intent{} = intent) do
    Intent.get!(intent.id)["userSays"]
    |> Enum.map(fn(v) -> v["data"] end)
    |> List.flatten()
    |> Enum.map(fn(v) -> String.downcase(v["text"]) end)
    |> Enum.uniq()
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
