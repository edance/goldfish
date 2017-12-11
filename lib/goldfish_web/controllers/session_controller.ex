defmodule GoldfishWeb.SessionController do
  use GoldfishWeb, :controller

  alias Goldfish.{Session, Guardian}

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, session_params) do
    case Session.login(session_params) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, "Logged in")
        |> redirect(to: "/")
      {:error, reason} ->
        conn
        |> put_flash(:info, reason)
        |> render("new.html")
    end
  end
end
