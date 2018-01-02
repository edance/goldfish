defmodule GoldfishWeb.Router do
  use GoldfishWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_room_id
    plug Guardian.Plug.Pipeline, module: Goldfish.Guardian, error_handler: Goldfish.AuthErrorHandler
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource, allow_blank: true
    plug :set_user
  end

  pipeline :authenticate_user do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GoldfishWeb do
    pipe_through :browser # Use the default browser stack

    get "/", HomeController, :index
    resources "/pages", PageController, only: [:index, :show]

    # Route to login
    resources "/sessions", SessionController, only: [:new, :create, :delete],
                                             singleton: true
  end

  scope "/admin", GoldfishWeb, as: :admin do
    pipe_through [:browser, :authenticate_user]

    resources "/pages", CMS.PageController
    resources "/rooms", Chat.RoomController, only: [:index, :show]
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

  defp put_room_id(conn, _) do
    case get_session(conn, :room_id) do
      nil ->
        token = Phoenix.Token.sign(conn, "room", get_ip_address(conn))
        conn
        |> put_session(:room_id, token)
        |> assign(:room_id, token)
      token -> assign(conn, :room_id, token)
    end
  end

  defp get_ip_address(conn) do
    case get_req_header(conn, "x-forwarded-for") do
      [x] -> x
      [] -> to_string(:inet_parse.ntoa(conn.remote_ip))
    end
  end
end
