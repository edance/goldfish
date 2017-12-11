defmodule GoldfishWeb.PageControllerTest do
  use GoldfishWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Evan Dancer"
  end
end
