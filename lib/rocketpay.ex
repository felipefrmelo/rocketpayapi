defmodule Rocketpay do
  alias Rocketpay.Users.Create, as: UserCreate
  alias Rocketpay.Users.List, as: UserList
  alias Rocketpay.Accounts.Deposit

  defdelegate create_user(params), to: UserCreate, as: :call

  defdelegate list_user(), to: UserList, as: :call

  defdelegate deposit(params), to: Deposit, as: :call
end
