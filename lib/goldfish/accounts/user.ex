defmodule Goldfish.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Goldfish.Accounts.User


  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> validate_length(:email, min: 1, max: 255)
    |> validate_format(:email, ~r/@/)
  end

  @doc false
  def registration_changeset(%User{} = user, attrs) do
    user
    |> changeset(attrs)
    |> cast(attrs, ~w(password), [])
    |> validate_length(:password, min: 8)
    |> put_password_hash
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Argon2.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
