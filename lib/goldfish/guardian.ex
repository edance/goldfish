defmodule Goldfish.Guardian do
  use Guardian, otp_app: :goldfish

  alias Goldfish.Accounts.User

  def subject_for_token(%User{} = user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    user = Goldfish.Accounts.get_user!(id)
    {:ok,  user}
  end
end
