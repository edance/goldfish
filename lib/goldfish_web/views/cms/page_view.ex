defmodule GoldfishWeb.CMS.PageView do
  use GoldfishWeb, :view

  alias Goldfish.CMS.Page

  def author_name(%Page{author: author}), do: author.user.email
end
