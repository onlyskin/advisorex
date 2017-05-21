defmodule Advisor.Core.Questions do
  alias Advisor.Repo
  alias Advisor.Core.Question

  def all() do
    Repo.all(Question)
    |> Enum.group_by(&( &1.kind))
    |> coerce()
  end

  defp coerce(elements) do
    elements
    |> Enum.map(fn({key,value}) -> {convert_key(key), value} end)
    |> Enum.into(%{})
  end

  defp convert_key(key) do
    case key do
      1 -> :technical
      2 -> :client
      3 -> :community
    end
  end
end