defmodule GoldfishWeb.PageView do
  use GoldfishWeb, :view

  def markdown(body) do
    Earmark.as_html!(body)
  end
end
