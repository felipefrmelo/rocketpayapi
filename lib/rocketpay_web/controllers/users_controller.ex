defmodule RocketpayWeb.UsersController do
  use RocketpayWeb, :controller

  alias Rocketpay.User

  def create(conn, params) do
    params
    |> Rocketpay.create_user()
    |> handle_reponse(conn)
  end

  def list(conn, _params) do
    Rocketpay.list_user()
    |> handle_reponse(conn)
  end

  defp handle_reponse(%{users: users}, conn) do

    conn
    |> put_status(:ok)
    |> render("list.json", %{users: users})
  end

  defp handle_reponse({:ok, %User{} = user}, conn) do
    conn
    |> put_status(:created)
    |> render("create.json", %{user: user})
  end

  defp handle_reponse({:error, result}, conn) do
    conn
    |> put_status(:bad_request)
    |> put_view(RocketpayWeb.ErrorView)
    |> render("400.json", result: result)
  end
end
