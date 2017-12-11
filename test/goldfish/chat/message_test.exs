defmodule Goldfish.Chat.MessageTest do
  use Goldfish.DataCase

  alias Goldfish.Chat.Message

  @valid_attrs %{body: "Hi"}

  test "changeset with valid attributes" do
    changeset = Message.changeset(%Message{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset, body too short " do
    changeset = Message.changeset(
      %Message{}, Map.put(@valid_attrs, :body, "")
    )
    refute changeset.valid?
  end

  test "changeset, body too long" do
    body = String.duplicate("A", 256)
    changeset = Message.changeset(
      %Message{}, Map.put(@valid_attrs, :body, body)
    )
    refute changeset.valid?
  end
end
