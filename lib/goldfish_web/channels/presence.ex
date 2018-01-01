defmodule GoldfishWeb.Presence do
  use Phoenix.Presence, otp_app: :goldfish,
                        pubsub_server: Goldfish.PubSub
end
