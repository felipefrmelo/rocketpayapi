Ecto.Adapters.SQL.Sandbox.mode(Rocketpay.Repo, :manual)

defmodule Rocketpay.AccountTest do
  use ExUnit.Case, async: true
  alias Rocketpay.{User, Account}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Rocketpay.Repo)
  end

  describe "create an account valid" do
    test "when there is a valid user should be create an account" do
      user = %{
        name: "Felipe",
        email: "felipe@test",
        age: 19,
        nickname: "teste",
        password: "123456"
      }

      {:ok,
       %User{nickname: nickname, id: id, account: %Account{balance: balance, id: account_id}}} =
        Rocketpay.create_user(user)

      assert nickname == "teste"
      assert Decimal.compare(balance, 0) == :eq
    end

    test "when there is no file with the given name, returns an error" do
      user = createUser()

      {:ok, account} = Rocketpay.deposit(%{"id" => user.account_id, "value" => "50.0"})
      assert  Decimal.equal?(account.balance, "50.0")

    end

    defp createUser() do
      user = %{
        name: "Felipe",
        email: "felipe@test",
        age: 19,
        nickname: "teste",
        password: "123456"
      }

      {:ok,
       %User{nickname: nickname, id: id, account: %Account{balance: balance, id: account_id}}} =
        Rocketpay.create_user(user)

      %{nickname: nickname, id: id, account_id: account_id, balance: balance}
    end
  end
end
