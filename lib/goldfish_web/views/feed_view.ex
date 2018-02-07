defmodule GoldfishWeb.FeedView do
  use GoldfishWeb, :view

  def date_format(entry) do
    entry.updated_at
    |> Timex.format!("%FT%T%:zZ", :strftime)
  end

  def html(entry) do
    Earmark.as_html!(entry.body)
  end
end
