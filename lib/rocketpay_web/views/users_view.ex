defmodule RocketpayWeb.UsersView do
  alias Rocketpay.{Account, User}

  def render("create.json", %{
        user: %User{
          id: id,
          name: name,
          nickname: nickname,
          account: %Account{balance: balance, id: account_id}
        }
      }) do
    [
      %{
        message: "User created",
        user: %{
          id: id,
          name: name,
          nickname: nickname,
          account: %{
            id: account_id,
            balance: balance
          }
        }
      }
    ]
  end

  def render("list.json", %{users: users}) do
    %{
      message: "List users",
      users:
        Enum.map(users, fn %{
                             id: id,
                             name: name,
                             nickname: nickname,
                             age: age,
                             account: %{
                               id: account_id,
                               balance: balance
                             }
                           } ->
          %{
            id: id,
            name: name,
            age: age,
            nickname: nickname,
            account: %{
              balance: balance,
              id: account_id
            }
          }
        end)
    }
  end
end
