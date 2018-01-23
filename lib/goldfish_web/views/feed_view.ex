defmodule GoldfishWeb.FeedView do
  use GoldfishWeb, :view

  def date_format(entry) do
    entry.inserted_at
    |> Timex.format!("%a, %d %b %Y %H:%M:%S GMT", :strftime)
  end
end
