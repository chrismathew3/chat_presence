defmodule ChatWeb.RegistrationController do
  use ChatWeb, :controller

  alias Chat.Users

  action_fallback(Web.FallbackController)

  plug(:put_layout, "session.html")

  def new(conn, _params) do
    conn
    |> assign(:changeset, Users.new())
    |> render("new.html")
  end

  def create(conn, %{"user" => params}) do
    case Users.create(params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome to Chat")
        |> put_session(:user_token, user.token)
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "There was an error, please try again")
        |> put_status(422)
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end
end
