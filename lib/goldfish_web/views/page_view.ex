defmodule GoldfishWeb.PageView do
  use GoldfishWeb, :view

  def title(_, %{ page: page }) do
    page.title
  end

  def title("projects.html", _) do
    "Projects"
  end

  def title(_x, _y) do
    "Posts"
  end

  def published_text(%{published_at: nil, updated_at: updated_at}) do
    "Updated at #{format_time(updated_at)}"
  end

  def published_text(%{published_at: published_at}) do
    "Published at #{format_time(published_at)}"
  end

  def markdown(body) do
    options = %Earmark.Options{code_class_prefix: "lang- language-"}
    Earmark.as_html!(body, options)
  end

  def snippet(page) do
    snippet = Earmark.as_html!(page.body)
    snippet = String.split(snippet, "</p>") |> List.first()
    "#{snippet}</p>"
  end

  defp format_time(time) do
    Timex.format!(time, "%B %-d, %Y", :strftime)
  end
end
