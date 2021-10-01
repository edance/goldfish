defmodule GoldfishWeb.SharedView do
  use GoldfishWeb, :view

  def nav_link(conn, text, opts) do
    opts = Keyword.merge(opts,
      class: "inline-block py-2 px-4 no-underline",
      class_active: "text-gray-900 font-bold",
      class_inactive: "text-gray-600 hover:text-gray-900 hover:text-underline"
    )
    active_link(conn, text, opts)
  end
end
