defmodule Rocketpay.Users.List do
  alias Rocketpay.{Repo, User}
  import Ecto.Query, only: [from: 2]

  def call() do
    Repo.all(from u in User, order_by: [desc: u.inserted_at]) |> Repo.preload(:account)
  end
end
