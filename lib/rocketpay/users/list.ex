defmodule Rocketpay.Users.List do
  alias Rocketpay.{Repo, User}
  import Ecto.Query, only: [from: 2]

  def call() do
   %{users: Repo.all(from u in User, order_by: u.inserted_at)}
  end
end
