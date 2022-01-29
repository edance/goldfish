defmodule Goldfish.Chat do
  @moduledoc """
  The Chat context.
  """

  import Ecto.Query, warn: false
  alias Goldfish.Repo

  alias Goldfish.Chat.Message
  alias Goldfish.Accounts.User
  alias Goldfish.MessageReporter

  @doc """
  Returns a list of recent messages.
  """
  def list_messages() do
    query = from m in Message,
      order_by: [desc: m.inserted_at],
      preload: [:user]
    Repo.all(query)
  end

  def list_rooms() do
    rooms = from m in Message,
      windows: [w: [partition_by: m.room_id, order_by: [desc: m.inserted_at]]],
      where: [bot: false],
      select: %{
        id: m.id,
        rank: row_number() |> over(:w),
        room_id: m.room_id,
      }

    query = from m in Message,
      join: r in subquery(rooms),
      on: m.id == r.id and r.rank == 1,
      order_by: [desc: m.inserted_at]

    Repo.all(query)
  end

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages(room_id)
      [%Message{}, ...]

  """
  def list_messages(room_id) do
    query = from m in Message,
      where: m.room_id == ^room_id,
      order_by: [desc: m.inserted_at],
      preload: [:user]
    Repo.all(query)
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message with a user

  ## Examples

    iex> create_message(%User{}, %{field: value})
    {:ok, %Message{}}

    iex> create_message(%User{}, %{field: bad_value})
    {:error, %Ecto.Changeset{}}

  """
  def create_message(%User{} = user, attrs) do
    message = %Message{}
    |> Message.changeset(attrs)
    |> Ecto.Changeset.put_change(:user_id, user.id)

    case Repo.insert(message) do
      {:ok, message} ->
        Task.start(fn -> MessageReporter.report_new_message(message) end)
        {:ok, message}
      error -> error
    end
  end

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs) do
    message = Message.changeset(%Message{}, attrs)

    case Repo.insert(message) do
      {:ok, message} ->
        Task.start(fn -> MessageReporter.report_new_message(message) end)
        {:ok, message}
      error -> error
    end
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{source: %Message{}}

  """
  def change_message(%Message{} = message) do
    Message.changeset(message, %{})
  end
end
