defmodule RocketpayWeb.AccountController do
  use RocketpayWeb, :controller

  alias Rocketpay.{ Account}


  action_fallback RocketpayWeb.FallbackController

  def deposit(conn, params) do
    with {:ok, %Account{} = account}  <- Rocketpay.deposit(params) do
      conn
      |> put_status(:ok)
      |> render("update.json", %{account: account})
    end
  end

  def list(conn, _params) do
    with users  <- Rocketpay.list_user() do
      conn
      |> put_status(:ok)
      |> render("list.json", %{users: users})
    end

  end

end
