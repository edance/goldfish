defmodule GoldfishWeb.SitemapView do
  use GoldfishWeb, :view

  def date_format(page) do
    page.inserted_at
    |> Timex.format!("%FT%T%:zZ", :strftime)
  end
end
