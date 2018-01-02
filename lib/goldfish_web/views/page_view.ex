defmodule GoldfishWeb.PageView do
  use GoldfishWeb, :view

  alias Goldfish.CMS.Page

  def author_name(%Page{author: author}), do: author.user.email

  def markdown(body) do
    Earmark.as_html!(body)
  end
end
