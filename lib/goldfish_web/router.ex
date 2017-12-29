defmodule GoldfishWeb.Router do
  use GoldfishWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Guardian.Plug.Pipeline, module: Goldfish.Guardian, error_handler: Goldfish.AuthErrorHandler
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource, allow_blank: true
    plug :set_user
    plug :put_user_token
  end

  pipeline :authenticate_user do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GoldfishWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/sessions", SessionController, only: [:new, :create, :delete],
                                             singleton: true
  end

  scope "/cms", GoldfishWeb.CMS, as: :cms do
    pipe_through [:browser, :authenticate_user]

    resources "/pages", PageController
  end

  # Other scopes may use custom stacks.
  # scope "/api", GoldfishWeb do
  #   pipe_through :api
  # end

  defp set_user(conn, _) do
    case Goldfish.Guardian.Plug.current_resource(conn) do
      nil -> conn
      user -> assign(conn, :current_user, user)
    end
  end

  defp put_user_token(conn, _) do
    case get_session(conn, :user_token) do
      nil ->
        ip_address = get_req_header(conn, "x-forwarded-for") || conn.remote_ip
        token = Phoenix.Token.sign(conn, "user socket", ip_address)
        conn
        |> put_session(:user_token, token)
        |> assign(:user_token, token)
      token ->
        conn |> assign(:user_token, token)
    end
  end
end
