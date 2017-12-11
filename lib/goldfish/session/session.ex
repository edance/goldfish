defmodule Goldfish.Session do
  @moduledoc """
  The Session context.
  """

  import Ecto.Query, warn: false
  import Comeonin.Argon2, only: [checkpw: 2, dummy_checkpw: 0]

  alias Goldfish.Repo
  alias Goldfish.Accounts.User

  @doc """
  Returns a user
  """
  def login(session_params) do
    user = Repo.get_by(User, email: session_params["email"])
    cond do
      user && checkpw(session_params["password"], user.password_hash) ->
        {:ok, user}
      user -> {:error, "invalid email or password"}
      true ->
        dummy_checkpw()
        {:error, "invalid email or password"}
    end
  end
end
