defmodule RocketpayWeb.UsersView do
  alias Rocketpay.User

  def render("create.json", %{user: %User{id: id, name: name, nickname: nickname}}) do
   [ %{
      message: "User created",
      user: %{
        id: id,
        name: name,
        nickname: nickname
      }
    }]
  end

  def render("list.json", %{users: users}) do

    IO.inspect(users)
   Enum.map(users, fn u -> %{
    message: "User list",
    user: %{
      id: u.id,
      name: u.name,
      age: u.age,
      nickname: u.nickname
    }
  }  end )
  end
end
