defmodule GoldfishWeb.PageView do
  use GoldfishWeb, :view

  def title(_, %{ page: page }) do
    page.title
  end

  def markdown(body) do
    options = %Earmark.Options{code_class_prefix: "lang- language-"}
    Earmark.as_html!(body, options)
  end
end
