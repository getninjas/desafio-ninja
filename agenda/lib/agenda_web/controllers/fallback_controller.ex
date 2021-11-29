defmodule AgendaWeb.FallbackController do
  alias AgendaWeb.ErrorView

  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use AgendaWeb, :controller

  @doc """
    handle the errors and show the user the json with the current error message.
  """
  def call(conn, {:error, content}) do
    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> render("400.json", content: content)
  end
end
