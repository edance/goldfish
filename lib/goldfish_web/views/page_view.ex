defmodule GoldfishWeb.PageView do
  use GoldfishWeb, :view

  def title(_, %{ page: page }) do
    page.title
  end

  def title(_, _) do
    "Posts"
  end

  def published_date(%{inserted_at: inserted_at}) do
    inserted_at
    |> Timex.format!("%B %-d, %Y", :strftime)
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
end
