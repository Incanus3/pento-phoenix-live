# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pento.Repo.insert!(%Pento.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Pento.Accounts

defmodule Users do
  def create(attributes) do
    case Accounts.register_user(attributes) do
      {:ok, user} ->
        IO.puts("user created")

      {:error, changeset} ->
        IO.puts("user couldn't be created due to the following errors:")
        IO.inspect(interpolate_error_messages(changeset))
    end
  end

  defp interpolate_error_messages(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end

Users.create(%{email: "jakubkalab@gmail.com", password: "testtesttest"})
