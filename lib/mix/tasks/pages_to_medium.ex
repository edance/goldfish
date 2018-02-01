defmodule Mix.Tasks.PagesToMedium do
  alias Goldfish.CMS
  alias Goldfish.CMS.Page
  alias GoldfishWeb.Endpoint
  alias GoldfishWeb.Router.Helpers
  alias Medium.Post

  def run(_) do
    Mix.Task.run("app.start", [])
    CMS.list_pages()
    |> Enum.each(&upload/1)
  end

  defp upload(%Page{medium_id: nil} = page) do
    page
    |> to_post()
    |> Map.merge(%{canonicalUrl: page_url(page)})
    |> Post.create_post()
    |> handle_response(page)
  end
  defp upload(_), do: nil

  defp handle_response({:ok, response}, page) do
    page
    |> CMS.update_page(%{medium_id: response.id})
  end
  defp handle_response(_, _), do: nil

  defp to_post(%Page{} = page) do
    url = page_url(page)
    content = "#{page.body}\n\n*Originally posted at [#{url}](#{url})*"
    %Post{title: page.title, content: content, contentFormat: "markdown"}
  end

  defp page_url(%Page{} = page) do
    Helpers.page_url(Endpoint, :show, page.slug)
  end
end
