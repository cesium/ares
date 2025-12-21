defmodule AresWeb.PageController do
  use AresWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
